import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:shapeshred/core/ui/main_layout.dart';
import 'package:shapeshred/features/auth/presentation/pages/login_page.dart';
import 'package:shapeshred/features/auth/presentation/pages/signup_page.dart';
import 'package:shapeshred/features/auth/presentation/pages/super_ultra_premium_onboarding_page.dart';
import 'package:shapeshred/features/training/presentation/pages/home_page.dart';
import 'package:shapeshred/features/training/presentation/pages/training_page.dart';
import 'package:shapeshred/features/nutrition/presentation/pages/nutrition_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/profile_page.dart';
import 'package:shapeshred/features/training/presentation/pages/workout_player/super_ultra_premium_workout_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/super_ultra_premium_analytics_detail_page.dart';

/// Rebuilds the router's redirect whenever the Firebase auth state changes.
class _AuthRefresh extends ChangeNotifier {
  late final StreamSubscription<User?> _sub;

  _AuthRefresh() {
    _sub = FirebaseAuth.instance
        .authStateChanges()
        .listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const Set<String> _authPaths = {'/onboarding', '/login', '/signup'};

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/onboarding',
    debugLogDiagnostics: kDebugMode,
    refreshListenable: _AuthRefresh(),
    redirect: (context, state) {
      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      final String location = state.matchedLocation;

      // '/signup' is deliberately NOT redirected for logged-in users: right
      // after account creation the signup page pushes the goal/metrics/level
      // profile flow, which a redirect would tear down.
      if (loggedIn && (location == '/onboarding' || location == '/login')) {
        return '/';
      }
      if (!loggedIn && !_authPaths.contains(location)) return '/onboarding';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const SuperUltraPremiumOnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),

      // Full-screen experiences (no bottom bar) on the root navigator.
      GoRoute(
        path: '/super-ultra-premium-workout',
        name: 'super-ultra-premium-workout',
        parentNavigatorKey: navigatorKey,
        builder: (context, state) => const SuperUltraPremiumWorkoutPage(),
      ),
      GoRoute(
        path: '/super-ultra-premium-analytics',
        name: 'super-ultra-premium-analytics',
        parentNavigatorKey: navigatorKey,
        builder: (context, state) =>
            const SuperUltraPremiumAnalyticsDetailPage(),
      ),

      // Main tabs: IndexedStack shell keeps each tab's state alive across
      // switches (no re-fetching, no scroll-position loss).
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainLayout(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/training',
              name: 'training',
              builder: (context, state) => const TrainingPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/nutrition',
              name: 'nutrition',
              builder: (context, state) => const NutritionPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ]),
        ],
      ),
    ],
  );
}
