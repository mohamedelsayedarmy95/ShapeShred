import 'package:go_router/go_router.dart';
import 'package:shapeshred/features/authentication/presentation/pages/login_page.dart';
import 'package:shapeshred/features/authentication/presentation/pages/signup_page.dart';
import 'package:shapeshred/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:shapeshred/features/training/presentation/pages/home_page.dart';
import 'package:shapeshred/features/profile/presentation/pages/profile_page.dart';
import 'package:shapeshred/features/training/presentation/pages/training_library_page.dart';
import 'package:shapeshred/features/training/presentation/pages/workout_player_page.dart';
import 'package:shapeshred/features/nutrition/presentation/pages/nutrition_dashboard_page.dart';
import 'package:shapeshred/features/nutrition/presentation/pages/meal_logger_page.dart';
import 'package:shapeshred/features/coach/presentation/pages/coach_chat_page.dart';
import 'package:shapeshred/features/coach/presentation/pages/daily_tasks_page.dart';
import 'package:shapeshred/features/coach/presentation/pages/progress_reports_page.dart';
import 'package:shapeshred/features/premium/presentation/pages/premium_page.dart';
import 'package:shapeshred/features/scanner/presentation/pages/inbody_scanner_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
          path: '/profile', builder: (context, state) => const ProfilePage()),
      GoRoute(
          path: '/training',
          builder: (context, state) => const TrainingLibraryPage()),
      GoRoute(
          path: '/workout-player',
          builder: (context, state) => const WorkoutPlayerPage()),
      GoRoute(
          path: '/nutrition',
          builder: (context, state) => const NutritionDashboardPage()),
      GoRoute(
          path: '/meal-logger',
          builder: (context, state) => const MealLoggerPage()),
      GoRoute(
          path: '/coach-chat',
          builder: (context, state) => const CoachChatPage()),
      GoRoute(
          path: '/daily-tasks',
          builder: (context, state) => const DailyTasksPage()),
      GoRoute(
          path: '/progress-reports',
          builder: (context, state) => const ProgressReportsPage()),
      GoRoute(
          path: '/premium', builder: (context, state) => const PremiumPage()),
      GoRoute(
          path: '/inbody-scanner',
          builder: (context, state) => const InBodyScannerPage()),
    ],
  );
}
