import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_muslim_companion/core/db/app_database.dart';
import 'package:new_muslim_companion/core/db/providers.dart';
import 'package:new_muslim_companion/main.dart';

void main() {
  testWidgets('App boots to the onboarding screen on first launch', (tester) async {
    // Overrides appDatabaseProvider with an in-memory database so this test
    // doesn't depend on path_provider's platform channel (unavailable by
    // default in widget tests) to locate a real database file on disk.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWith((ref) => AppDatabase(NativeDatabase.memory()))],
        child: const NewMuslimCompanionApp(),
      ),
    );

    // The loading screen shows an indefinitely-animating spinner, which
    // pumpAndSettle() never settles past — pump a bounded number of times
    // instead to let the async seed import and onboarding-status read
    // resolve. runAsync() breaks out of the fake-time zone so the real
    // asset-bundle I/O (114 Quran files + everything else bundled) can
    // actually progress, rather than relying purely on simulated time.
    await tester.runAsync(() => Future.delayed(const Duration(seconds: 2)));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('Welcome to New Muslim Companion'), findsOneWidget);
    expect(find.text('I have accepted Islam'), findsOneWidget);

    // Dispose the widget tree (and with it, the ProviderScope + drift watch
    // streams) within the test body, then settle so drift's zero-duration
    // cleanup timers fire before the test binding's teardown asserts no
    // timers are left pending (safe now — no infinite spinner remains).
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
