import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shapeshred/firebase_options.dart';
import 'package:logger/logger.dart';

class FirebaseService {
  FirebaseService._();
  
  static final Logger _logger = Logger();

  static Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Enable Crashlytics in release mode
    if (!kDebugMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    // Configure Analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(!kDebugMode);

    // Configure Messaging
    await _configureMessaging();
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

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          _logger.d('Got a message whilst in the foreground!');
          _logger.d('Message data: ${message.data}');

          if (message.notification != null) {
            _logger.d('Message also contained a notification: ${message.notification}');
          }
        }
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
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
}

