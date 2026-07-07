import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shapeshred/core/services/secure_storage_service.dart';

/// Ultra Premium Security Audit Service
/// Monitors and reports security issues in real-time
class SecurityAudit {
  SecurityAudit._();

  static final List<SecurityEvent> _events = [];
  static const int _maxEvents = 100;

  /// Log a security event
  static void logEvent(SecurityEventType type, String message, {Map<String, dynamic>? metadata}) {
    final event = SecurityEvent(
      type: type,
      message: message,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _events.add(event);
    if (_events.length > _maxEvents) {
      _events.removeAt(0);
    }

    // Log critical events
    if (type == SecurityEventType.critical || type == SecurityEventType.high) {
      _logCriticalEvent(event);
    }
  }

  static void _logCriticalEvent(SecurityEvent event) {
    // In production, this would send to security monitoring service
    if (kDebugMode) {
      print('[SECURITY AUDIT] ${event.type.name}: ${event.message}');
      if (event.metadata != null) {
        print('[SECURITY AUDIT] Metadata: ${event.metadata}');
      }
    }
  }

  /// Get all security events
  static List<SecurityEvent> getEvents() {
    return List.unmodifiable(_events);
  }

  /// Get events by type
  static List<SecurityEvent> getEventsByType(SecurityEventType type) {
    return _events.where((e) => e.type == type).toList();
  }

  /// Clear all events
  static void clearEvents() {
    _events.clear();
  }

  /// Check for suspicious activity
  static List<SecurityEvent> getSuspiciousActivity() {
    return _events.where((e) => 
      e.type == SecurityEventType.critical || 
      e.type == SecurityEventType.high
    ).toList();
  }

  /// Export security report
  static Map<String, dynamic> exportReport() {
    return {
      'total_events': _events.length,
      'critical_events': getEventsByType(SecurityEventType.critical).length,
      'high_events': getEventsByType(SecurityEventType.high).length,
      'medium_events': getEventsByType(SecurityEventType.medium).length,
      'low_events': getEventsByType(SecurityEventType.low).length,
      'events': _events.map((e) => e.toJson()).toList(),
    };
  }
}

enum SecurityEventType {
  critical,
  high,
  medium,
  low,
  info,
}

class SecurityEvent {
  final SecurityEventType type;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  SecurityEvent({
    required this.type,
    required this.message,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

/// Security Monitoring Utility
class SecurityMonitor {
  SecurityMonitor._();

  /// Monitor for root/jailbreak detection
  static Future<bool> isDeviceSecure() async {
    if (!kReleaseMode) return true; // Allow debugging in dev

    bool isSecure = true;

    if (Platform.isAndroid) {
      // Check for common root indicators
      isSecure = await _checkAndroidRoot();
    } else if (Platform.isIOS) {
      // Check for jailbreak indicators
      isSecure = await _checkIOSJailbreak();
    }

    if (!isSecure) {
      SecurityAudit.logEvent(
        SecurityEventType.critical,
        'Device security compromised',
        metadata: {'platform': Platform.operatingSystem},
      );
    }

    return isSecure;
  }

  static Future<bool> _checkAndroidRoot() async {
    // Basic root detection
    final indicators = [
      '/system/app/Superuser.apk',
      '/sbin/su',
      '/system/bin/su',
      '/system/xbin/su',
      '/data/local/xbin/su',
      '/data/local/bin/su',
      '/system/sd/xbin/su',
      '/system/bin/failsafe/su',
      '/data/local/su',
      '/su/bin/su',
    ];

    for (final path in indicators) {
      if (await File(path).exists()) {
        return false;
      }
    }

    return true;
  }

  static Future<bool> _checkIOSJailbreak() async {
    // Basic jailbreak detection
    final indicators = [
      '/Applications/Cydia.app',
      '/Library/MobileSubstrate/MobileSubstrate.dylib',
      '/bin/bash',
      '/usr/sbin/sshd',
      '/etc/apt',
      '/private/var/lib/apt/',
    ];

    for (final path in indicators) {
      if (await File(path).exists()) {
        return false;
      }
    }

    return true;
  }

  /// Check for emulator detection
  static bool isEmulator() {
    if (kDebugMode) return true; // Allow emulators in dev

    bool isEmulator = false;

    if (Platform.isAndroid) {
      isEmulator = _checkAndroidEmulator();
    } else if (Platform.isIOS) {
      isEmulator = _checkIOSEmulator();
    }

    if (isEmulator) {
      SecurityAudit.logEvent(
        SecurityEventType.medium,
        'Running on emulator',
        metadata: {'platform': Platform.operatingSystem},
      );
    }

    return isEmulator;
  }

  static bool _checkAndroidEmulator() {
    return Platform.environment.containsKey('ANDROID_ROOT') ||
           Platform.environment.containsKey('ANDROID_EMULATOR');
  }

  static bool _checkIOSEmulator() {
    return Platform.environment.containsKey('SIMULATOR_DEVICE_NAME') ||
           Platform.environment.containsKey('IPHONE_SIMULATOR_DEVICE_NAME');
  }

  /// Check for debug mode in production
  static bool isDebugMode() {
    if (kDebugMode) {
      SecurityAudit.logEvent(
        SecurityEventType.low,
        'Running in debug mode',
      );
      return true;
    }
    return false;
  }

  /// Check for secure storage integrity
  static Future<bool> isSecureStorageIntact() async {
    try {
      final testKey = '_security_test_key';
      final testValue = '_security_test_value';
      
      await SecureStorageService.write(testKey, testValue);
      final readValue = await SecureStorageService.read(testKey);
      await SecureStorageService.delete(testKey);
      
      if (readValue != testValue) {
        SecurityAudit.logEvent(
          SecurityEventType.high,
          'Secure storage integrity check failed',
        );
        return false;
      }
      
      return true;
    } catch (e) {
      SecurityAudit.logEvent(
        SecurityEventType.high,
        'Secure storage error',
        metadata: {'error': e.toString()},
      );
      return false;
    }
  }
}
