import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_muslim_companion/core/db/app_database.dart';
import 'package:new_muslim_companion/core/db/providers.dart';
import 'package:new_muslim_companion/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Widget-test version of the Foundation Package's required vertical
/// slice (see docs/testing/testing-plan.md). A true on-device/browser
/// `integration_test` run isn't possible on this dev machine yet — Windows
/// desktop needs the Visual Studio C++ workload (not installed), and the
/// `integration_test` package doesn't support `flutter test -d chrome` in
/// this Flutter version (it needs `flutter drive` + chromedriver, a
/// separate setup). This test exercises the exact same real widget tree
/// and providers via `flutter_test` instead, which covers the same
/// behaviour end-to-end without those extra toolchains.
Future<void> _settle(WidgetTester tester, {int ticks = 10}) async {
  for (var i = 0; i < ticks; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('onboarding -> Stage 1 Lesson 1 -> mark complete -> Home reflects progress + prayer times, '
      'entirely offline (in-memory DB, no network)', (tester) async {
    // LocationController reads SharedPreferences on startup; without this,
    // the plugin's method channel has no test-time mock and the future
    // never resolves, leaving the prayer-times card stuck loading.
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWith((ref) => AppDatabase(NativeDatabase.memory()))],
        child: const NewMuslimCompanionApp(),
      ),
    );

    await _settle(tester);

    // 1. Onboarding screen appears on first launch.
    expect(find.text('Welcome to New Muslim Companion'), findsOneWidget);

    // 2. Answer the background question and continue.
    await tester.tap(find.text('I have accepted Islam'));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await _settle(tester);

    // 3. Home dashboard shows "Continue Learning" pointing at Stage 1
    // Lesson 1 ("Who is Allah?") since nothing is completed yet.
    expect(find.text('Who is Allah?'), findsWidgets);
    expect(find.text('Continue Learning'), findsOneWidget);

    // A prayer-times card should render a concrete "Next: <Prayer> at
    // <time>" line — proves the offline adhan_dart calculation ran.
    expect(find.textContaining('Next:'), findsOneWidget);

    // 4. Open the lesson and mark it complete. The lesson body is long
    // enough that the button is off-screen until scrolled into view —
    // Flutter's ListView only builds/attaches on-screen (+ cache extent)
    // children, even for the fixed `ListView(children: ...)` constructor.
    await tester.tap(find.text('Continue Learning'));
    await _settle(tester);

    await tester.scrollUntilVisible(find.text('Mark Complete'), 300);
    await _settle(tester);

    expect(find.text('Mark Complete'), findsOneWidget);
    await tester.tap(find.text('Mark Complete'));
    await _settle(tester);

    expect(find.text('Completed'), findsOneWidget);

    // 5. Back on Home, the dashboard now points at the next lesson
    // (Stage 1 Lesson 2 - "The Shahadah"), proving progress persisted.
    await tester.pageBack();
    await _settle(tester);

    expect(find.textContaining('Shahadah'), findsWidgets);

    // Clean teardown so drift's stream-cleanup timers don't trip the
    // test binding's "no pending timers" invariant. Several concurrent
    // watch streams are active on this screen (progress,
    // continue-learning, location, daily dua); `runAsync` executes a
    // real (non-fake-async) event-loop turn so their zero-duration
    // cleanup timers actually fire before the test ends.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
