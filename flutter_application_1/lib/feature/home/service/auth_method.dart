import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleSigninService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn signIn = GoogleSignIn.instance;

  static bool isInitialize = false;

  Future<void> initSignin() async {
    if (!isInitialize) {
      await signIn.initialize(
        serverClientId:
            '406749288153-km0bphfikgs9a6om7tfdeh6u0r7blceq.apps.googleusercontent.com',
      );
    }
    isInitialize = true;
  }

  // Sign in with google
  Future<UserCredential?> signInWithGoogleFirebase({
    required String accessToken,
    required String idToken,
  }) async {
    try {
      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // Sign in to Firebase with credential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Reference to Firestore document
        final userDoc = FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          // Save user info in Firestore if not exists
          await userDoc.set({
            'uid': user.uid,
            'name': user.displayName ?? "",
            'email': user.email ?? "",
            'photoURL': user.photoURL ?? "",
            'provider': "google",
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential;
    } catch (e) {
      print("Error signing in with Google Firebase: $e");
      return null;
    }
  }
}
