import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shapeshred/core/services/firebase_service.dart';

class GoogleSignInService {
  GoogleSignInService._();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = 
          await FirebaseService.auth.signInWithCredential(credential);

      // Log analytics event
      await FirebaseService.analytics.logLogin(loginMethod: 'google');

      return userCredential;
    } catch (e) {
      // Log error to Crashlytics
      await FirebaseService.crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      FirebaseService.auth.signOut(),
    ]);
  }

  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  static GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}
