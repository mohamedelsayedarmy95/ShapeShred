import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shapeshred/core/utils/helpers/haptic_helper.dart';

/// Ultra Premium Biometric Authentication Service
/// Supports Face ID, Touch ID, and fingerprint authentication
class BiometricService {
  BiometricService._();

  static final LocalAuthentication _localAuth = LocalAuthentication();
  static bool _isAvailable = false;
  static bool _isInitialized = false;

  /// Initialize biometric service
  static Future<void> initialize() async {
    try {
      _isAvailable = await _localAuth.canCheckBiometrics;
      _isAvailable = _isAvailable || await _localAuth.isDeviceSupported();
      _isInitialized = true;
    } catch (e) {
      _isAvailable = false;
      _isInitialized = true;
    }
  }

  /// Check if biometric authentication is available
  static bool get isAvailable => _isAvailable;

  /// Check if service is initialized
  static bool get isInitialized => _isInitialized;

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    if (!_isAvailable) return [];
    return await _localAuth.getAvailableBiometrics();
  }

  /// Authenticate with biometrics
  /// 
  /// Returns true if authentication succeeds, false otherwise
  static Future<bool> authenticate({
    String localizedReason = 'Authenticate to continue',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
    bool biometricOnly = false,
  }) async {
    if (!_isAvailable) {
      HapticHelper.errorImpact();
      return false;
    }

    try {
      HapticHelper.lightImpact();
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        useErrorDialogs: useErrorDialogs,
        stickyAuth: stickyAuth,
        biometricOnly: biometricOnly,
      );

      if (didAuthenticate) {
        HapticHelper.successImpact();
      } else {
        HapticHelper.errorImpact();
      }

      return didAuthenticate;
    } on PlatformException catch (e) {
      HapticHelper.errorImpact();
      // Handle specific biometric errors
      if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
        // User needs to unlock device with PIN/Pattern
        return false;
      }
      return false;
    } catch (e) {
      HapticHelper.errorImpact();
      return false;
    }
  }

  /// Cancel ongoing authentication
  static Future<void> cancelAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      // Ignore cancellation errors
    }
  }

  /// Check if device has Face ID
  static Future<bool> hasFaceID() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }

  /// Check if device has Touch ID or fingerprint
  static Future<bool> hasFingerprint() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint) ||
        biometrics.contains(BiometricType.strong);
  }

  /// Get user-friendly biometric type name
  static Future<String> getBiometricTypeName() async {
    final biometrics = await getAvailableBiometrics();
    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (biometrics.contains(BiometricType.fingerprint) ||
        biometrics.contains(BiometricType.strong)) {
      return 'Touch ID';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Iris Scanner';
    } else if (biometrics.isNotEmpty) {
      return 'Biometric';
    }
    return 'None';
  }
}
