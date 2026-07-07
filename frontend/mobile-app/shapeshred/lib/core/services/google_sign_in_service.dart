import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shapeshred/core/services/firebase_service.dart';
import 'package:shapeshred/core/services/biometric_service.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

/// Ultra Premium Google Sign-In Service
/// Enhanced with biometric authentication and premium error handling
class GoogleSignInService {
  GoogleSignInService._();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  /// Sign in with Google with optional biometric verification
  static Future<UserCredential?> signInWithGoogle({
    bool requireBiometric = false,
  }) async {
    try {
      // Check biometric if required
      if (requireBiometric) {
        final hasBiometric = await BiometricService.isAvailable;
        if (hasBiometric) {
          final biometricSuccess = await BiometricService.authenticate(
            localizedReason: 'Authenticate to sign in with Google',
          );
          if (!biometricSuccess) {
            return null;
          }
        }
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        HapticHelper.lightImpact();
        return null;
      }

      HapticHelper.successImpact();

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
      await FirebaseService.logLogin(loginMethod: 'google');
      
      // Set user properties for analytics
      await FirebaseService.setUserProperty(
        name: 'sign_in_method',
        value: 'google',
      );

      return userCredential;
    } catch (e) {
      // Log error to Crashlytics
      await FirebaseService.crashlytics.recordError(e, StackTrace.current);
      HapticHelper.errorImpact();
      rethrow;
    }
  }

  /// Sign out from Google and Firebase
  static Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        FirebaseService.auth.signOut(),
      ]);
      HapticHelper.lightImpact();
    } catch (e) {
      await FirebaseService.crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Check if user is signed in with Google
  static Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current Google user
  static GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
  
  /// Silent sign-in for premium UX
  static Future<UserCredential?> signInSilently() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await FirebaseService.auth.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      // Silent sign-in failed, user will need to sign in manually
      return null;
    }
  }
  
  /// Disconnect from Google (revoke access)
  static Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      await FirebaseService.auth.signOut();
      HapticHelper.lightImpact();
    } catch (e) {
      await FirebaseService.crashlytics.recordError(e, StackTrace.current);
      rethrow;
    }
  }
}
