import 'package:flutter_application_1/feature/home/service/auth_method.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  setUpAll(() async {
    // Initialize Firebase before running any tests
    await Firebase.initializeApp();
  });

  test('signInWithGoogleFirebase test', () async {
    final service = GoogleSigninService();

    // fake tokens
    String fakeAccessToken = 'FAKE_ACCESS_TOKEN';
    String fakeIdToken = 'FAKE_ID_TOKEN';

    final result = await service.signInWithGoogleFirebase(
      accessToken: fakeAccessToken,
      idToken: fakeIdToken,
    );

    expect(result, null); // should be null because tokens are fake
  });
}
