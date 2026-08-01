import 'package:go_router/go_router.dart';

import '../features/community/community_screen.dart';
import '../features/duas/dua_library_placeholder_screen.dart';
import '../features/home/home_screen.dart';
import '../features/journal/journal_entry_screen.dart';
import '../features/journal/journal_list_screen.dart';
import '../features/learning/learning_roadmap_screen.dart';
import '../features/learning/lesson_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/prayer/prayer_placeholder_screen.dart';
import 'app_shell.dart';

const _tabPaths = ['/home', '/roadmap', '/prayer', '/duas', '/community', '/journal'];

/// Built once, after [AppStartupGate] has resolved the seed import and the
/// onboarding status — so [initialLocation] is decided from real data
/// rather than racing an async provider. There is no scenario in this
/// phase where onboarding status flips back to incomplete while the app is
/// running, so no `redirect` callback is needed: the onboarding screen
/// itself calls `context.go('/home')` on completion.
GoRouter buildAppRouter({required bool onboardingComplete}) {
  return GoRouter(
    initialLocation: onboardingComplete ? '/home' : '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(
        path: '/lesson/:id',
        builder: (context, state) => LessonScreen(lessonId: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(path: '/journal/new', builder: (context, state) => const JournalEntryScreen()),
      GoRoute(
        path: '/journal/:id',
        builder: (context, state) => JournalEntryScreen(entryId: int.parse(state.pathParameters['id']!)),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final index = _tabPaths.indexWhere((p) => state.matchedLocation.startsWith(p));
          return AppShell(
            currentIndex: index < 0 ? 0 : index,
            onDestinationSelected: (i) => context.go(_tabPaths[i]),
            child: child,
          );
        },
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/roadmap', builder: (context, state) => const LearningRoadmapScreen()),
          GoRoute(path: '/prayer', builder: (context, state) => const PrayerPlaceholderScreen()),
          GoRoute(path: '/duas', builder: (context, state) => const DuaLibraryPlaceholderScreen()),
          GoRoute(path: '/community', builder: (context, state) => const CommunityScreen()),
          GoRoute(path: '/journal', builder: (context, state) => const JournalListScreen()),
        ],
      ),
    ],
  );
}
