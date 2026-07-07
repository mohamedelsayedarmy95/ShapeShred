import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shapeshred/firebase_options.dart';
import 'package:shapeshred/core/services/privacy_service.dart';
import 'package:logger/logger.dart';

class FirebaseService {
  FirebaseService._();
  
  static final Logger _logger = Logger();

  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize with privacy compliance
    await _initializeWithPrivacy();

    // Configure Messaging
    await _configureMessaging();
  }

  static Future<void> _initializeWithPrivacy() async {
    // Get privacy consent
    final analyticsConsent = await PrivacyService.getAnalyticsConsent();
    final crashlyticsConsent = await PrivacyService.getCrashlyticsConsent();

    // Enable Crashlytics with consent
    if (crashlyticsConsent && !kDebugMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    // Configure Analytics with consent
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(analyticsConsent && !kDebugMode);
    
    // Set default parameters for premium analytics
    if (analyticsConsent && !kDebugMode) {
      await FirebaseAnalytics.instance.setDefaultEventParameters({
        'app_version': '1.0.0',
        'platform': kIsWeb ? 'web' : 'mobile',
      });
    }
    
    // Set user identifier for crash reporting
    final user = auth.currentUser;
    if (user != null && crashlyticsConsent) {
      await FirebaseCrashlytics.instance.setUserIdentifier(user.uid);
    }
  }

  static Future<void> _configureMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      String? token = await messaging.getToken();
      if (kDebugMode) {
        _logger.d('FCM Token: $token');
      }
      
      // Save token to Firestore for user
      if (token != null) {
        await _saveFCMToken(token);
      }

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          _logger.d('Got a message whilst in the foreground!');
          _logger.d('Message data: ${message.data}');

          if (message.notification != null) {
            _logger.d('Message also contained a notification: ${message.notification}');
          }
        }
        
        // Handle foreground messages with premium notification
        _handleForegroundMessage(message);
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Handle messages when app is in terminated state
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleBackgroundMessageTap(initialMessage);
      }
      
      // Handle message opened from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _logger.d('Message opened from background: ${message.messageId}');
        _handleBackgroundMessageTap(message);
      });
    }
  }
  
  static Future<void> _saveFCMToken(String token) async {
    final user = auth.currentUser;
    if (user == null) return;
    
    // Save token to Firestore for push notifications
    try {
      await firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.e('Failed to save FCM token: $e');
    }
  }
  
  static void _handleForegroundMessage(RemoteMessage message) {
    // Show in-app notification for foreground messages
    // This would show a premium notification banner
  }
  
  static void _handleBackgroundMessageTap(RemoteMessage message) {
    // Navigate to relevant screen based on message data
    // This would implement deep linking from notifications
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    if (kDebugMode) {
      _logger.d('Handling a background message: ${message.messageId}');
    }
  }

  // Auth Instance
  static FirebaseAuth get auth => FirebaseAuth.instance;

  // Firestore Instance
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // Analytics Instance
  static FirebaseAnalytics get analytics => FirebaseAnalytics.instance;

  // Crashlytics Instance
  static FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  // Messaging Instance
  static FirebaseMessaging get messaging => FirebaseMessaging.instance;
  
  /// Subscribe to a topic for targeted notifications
  static Future<void> subscribeToTopic(String topic) async {
    await messaging.subscribeToTopic(topic);
    _logger.d('Subscribed to topic: $topic');
  }
  
  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await messaging.unsubscribeFromTopic(topic);
    _logger.d('Unsubscribed from topic: $topic');
  }
  
  /// Log premium analytics event
  static Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    if (!kDebugMode) {
      await analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    }
  }
  
  /// Set user properties for analytics
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (!kDebugMode) {
      await analytics.setUserProperty(name: name, value: value);
    }
  }
  
  /// Log screen view for analytics
  static Future<void> logScreenView({
    required String screenName,
    String? screenClassOverride,
  }) async {
    if (!kDebugMode) {
      await analytics.logScreenView(
        screenName: screenName,
        screenClassOverride: screenClassOverride,
      );
    }
  }
  
  /// Log login event for analytics
  static Future<void> logLogin({required String loginMethod}) async {
    if (!kDebugMode) {
      await analytics.logLogin(loginMethod: loginMethod);
    }
  }
  
  /// Log sign up event for analytics
  static Future<void> logSignUp({required String signUpMethod}) async {
    if (!kDebugMode) {
      await analytics.logSignUp(signUpMethod: signUpMethod);
    }
  }
}

