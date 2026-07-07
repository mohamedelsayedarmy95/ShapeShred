import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shapeshred/core/ui/main_layout.dart';
import 'package:shapeshred/features/training/presentation/pages/home_page.dart';
import 'package:shapeshred/features/training/presentation/pages/training_page.dart';
import 'package:shapeshred/features/nutrition/presentation/pages/nutrition_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/profile_page.dart';
import 'package:shapeshred/features/auth/presentation/pages/onboarding_page.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  // TODO: Replace with actual auth state check
  static bool _isOnboardingComplete = false;

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: _isOnboardingComplete ? '/' : '/onboarding',
    debugLogDiagnostics: true,
    routes: [
      // Onboarding Route
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Main App Routes
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(
            child: child,
            currentIndex: _getCurrentIndex(state.uri.path),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/training',
            name: 'training',
            builder: (context, state) => const TrainingPage(),
          ),
          GoRoute(
            path: '/nutrition',
            name: 'nutrition',
            builder: (context, state) => const NutritionPage(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );

  static int _getCurrentIndex(String path) {
    switch (path) {
      case '/':
        return 0;
      case '/training':
        return 1;
      case '/nutrition':
        return 2;
      case '/profile':
        return 3;
      default:
        return 0;
    }
  }
}
