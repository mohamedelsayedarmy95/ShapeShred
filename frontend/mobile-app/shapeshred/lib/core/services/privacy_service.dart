import 'package:flutter/material.dart';
import 'package:shapeshred/core/services/secure_storage_service.dart';

/// Ultra Premium Privacy & GDPR Compliance Service
/// Manages user consent, data collection preferences, and privacy settings
class PrivacyService {
  PrivacyService._();

  static const String _consentKey = 'privacy_consent_given';
  static const String _analyticsConsentKey = 'analytics_consent';
  static const String _crashlyticsConsentKey = 'crashlytics_consent';
  static const String _marketingConsentKey = 'marketing_consent';
  static const String _consentDateKey = 'consent_date';

  /// Check if user has given privacy consent
  static Future<bool> hasGivenConsent() async {
    final consent = await SecureStorageService.read(_consentKey);
    return consent == 'true';
  }

  /// Get consent date
  static Future<DateTime?> getConsentDate() async {
    final dateStr = await SecureStorageService.read(_consentDateKey);
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  /// Save privacy consent
  static Future<void> saveConsent({
    required bool analytics,
    required bool crashlytics,
    required bool marketing,
  }) async {
    final now = DateTime.now().toIso8601String();
    await Future.wait([
      SecureStorageService.write(_consentKey, 'true'),
      SecureStorageService.write(_analyticsConsentKey, analytics.toString()),
      SecureStorageService.write(_crashlyticsConsentKey, crashlytics.toString()),
      SecureStorageService.write(_marketingConsentKey, marketing.toString()),
      SecureStorageService.write(_consentDateKey, now),
    ]);
  }

  /// Get analytics consent
  static Future<bool> getAnalyticsConsent() async {
    final consent = await SecureStorageService.read(_analyticsConsentKey);
    return consent == 'true';
  }

  /// Get crashlytics consent
  static Future<bool> getCrashlyticsConsent() async {
    final consent = await SecureStorageService.read(_crashlyticsConsentKey);
    return consent == 'true';
  }

  /// Get marketing consent
  static Future<bool> getMarketingConsent() async {
    final consent = await SecureStorageService.read(_marketingConsentKey);
    return consent == 'true';
  }

  /// Update specific consent
  static Future<void> updateConsent({
    bool? analytics,
    bool? crashlytics,
    bool? marketing,
  }) async {
    if (analytics != null) {
      await SecureStorageService.write(_analyticsConsentKey, analytics.toString());
    }
    if (crashlytics != null) {
      await SecureStorageService.write(_crashlyticsConsentKey, crashlytics.toString());
    }
    if (marketing != null) {
      await SecureStorageService.write(_marketingConsentKey, marketing.toString());
    }
  }

  /// Revoke all consent (GDPR right to be forgotten)
  static Future<void> revokeConsent() async {
    await Future.wait([
      SecureStorageService.delete(_consentKey),
      SecureStorageService.delete(_analyticsConsentKey),
      SecureStorageService.delete(_crashlyticsConsentKey),
      SecureStorageService.delete(_marketingConsentKey),
      SecureStorageService.delete(_consentDateKey),
    ]);
  }

  /// Get all consent settings
  static Future<Map<String, bool>> getAllConsents() async {
    return {
      'analytics': await getAnalyticsConsent(),
      'crashlytics': await getCrashlyticsConsent(),
      'marketing': await getMarketingConsent(),
    };
  }

  /// Check if consent needs to be updated (older than 1 year)
  static Future<bool> needsConsentUpdate() async {
    final consentDate = await getConsentDate();
    if (consentDate == null) return true;
    final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
    return consentDate.isBefore(oneYearAgo);
  }
}
