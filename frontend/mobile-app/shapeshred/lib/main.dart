import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/design_system/theme/app_theme.dart';
import 'core/design_system/theme/dark_theme.dart';
import 'core/design_system/tokens/colors.dart';
import 'core/routes/app_router.dart';
import 'core/services/secure_storage_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/firebase_service.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: AppGreyscale.white,
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppGreyscale.gray900,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Application Error',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppGreyscale.gray900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'An unexpected error occurred during startup. Please check the console for details.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTextColors.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Firebase Service
    await FirebaseService.initialize();

    // Initialize Secure Storage
    await SecureStorageService.initialize();

    // Initialize Theme Service
    await ThemeService.initialize();

    // Set up global error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('Flutter Error: ${details.exception}');
      FlutterError.presentError(details);
    };

    // Lock orientation to portrait
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppGreyscale.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    runApp(const ProviderScope(child: ShapeShredApp()));
  } catch (e, stackTrace) {
    debugPrint('APP STARTUP ERROR: $e');
    debugPrint('STACK TRACE: $stackTrace');
    runApp(const ProviderScope(child: ErrorScreen()));
  }
}

class ShapeShredApp extends StatefulWidget {
  const ShapeShredApp({super.key});

  @override
  State<ShapeShredApp> createState() => _ShapeShredAppState();
}

class _ShapeShredAppState extends State<ShapeShredApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeService.modeNotifier,
          builder: (context, themeMode, _) {
            return MaterialApp.router(
              title: 'ShapeShred',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppDarkTheme.theme,
              themeMode: themeMode,
              routerConfig: AppRouter.router,
            );
          },
        );
      },
    );
  }
}
