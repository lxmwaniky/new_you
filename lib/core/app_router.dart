import 'package:go_router/go_router.dart';

import '../features/auth/home_screen.dart';
import '../features/dashboard/account_screen.dart';
import '../features/checkin/checkin_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/journal/journal_entry_screen.dart';
import '../features/triggers/trigger_screen.dart';
import '../features/goals/goal_screen.dart';
import '../features/help/help_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
      routes: [
        GoRoute(
          path: 'checkin',
          builder: (context, state) => const CheckInScreen(),
        ),
        GoRoute(
          path: 'journal',
          builder: (context, state) => const JournalScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const JournalEntryScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'triggers',
          builder: (context, state) => const TriggerScreen(),
        ),
        GoRoute(path: 'goals', builder: (context, state) => const GoalScreen()),
      ],
    ),
    // Standalone Chat Route
    GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
  ],
);
