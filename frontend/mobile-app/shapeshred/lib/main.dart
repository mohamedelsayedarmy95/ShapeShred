import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/design_system/theme/app_theme.dart';
import 'core/design_system/tokens/colors.dart';
import 'core/design_system/tokens/typography.dart';
import 'core/routes/app_router.dart';
import 'core/services/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Secure Storage
  await SecureStorageService.initialize();
  
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
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ShapeShredApp());
}

class ErrorBoundary extends StatelessWidget {
  final Widget child;
  const ErrorBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ErrorWidget.builder((details) {
      return Scaffold(
        backgroundColor: AppColorPalette.pureWhite,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: AppColorPalette.gray900,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Something went wrong',
                    style: AppTypography.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'An unexpected error occurred. Please restart the app.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppTextColor.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class ShapeShredApp extends StatelessWidget {
  const ShapeShredApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'ShapeShred',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
