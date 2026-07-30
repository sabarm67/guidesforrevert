import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/db/providers.dart';
import 'features/onboarding/onboarding_repository.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: NewMuslimCompanionApp()));
}

/// Root widget. Awaits the one-time seed import and the first read of
/// onboarding status before switching from a loading `MaterialApp` to the
/// real `MaterialApp.router` — this way `buildAppRouter`'s
/// `initialLocation` is decided from real data instead of racing an async
/// Riverpod provider, while still using `MaterialApp.router` throughout
/// (rather than nesting a `Router` inside a plain `MaterialApp`), so
/// go_router's web URL sync and system back-button integration work
/// correctly once the real app is shown.
class NewMuslimCompanionApp extends ConsumerWidget {
  const NewMuslimCompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seedImport = ref.watch(seedImportProvider);
    final onboarding = ref.watch(onboardingStatusProvider);

    if (seedImport.isLoading || onboarding.isLoading) {
      return MaterialApp(
        title: 'New Muslim Companion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (seedImport.hasError) {
      return MaterialApp(
        title: 'New Muslim Companion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: Text('Failed to load content: ${seedImport.error}'))),
      );
    }

    final router = buildAppRouter(onboardingComplete: onboarding.valueOrNull != null);

    return MaterialApp.router(
      title: 'New Muslim Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
