import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';

class OnboardingRepository {
  OnboardingRepository(this._db);

  final AppDatabase _db;

  Future<OnboardingAnswer?> current() {
    return _db.select(_db.onboardingAnswers).getSingleOrNull();
  }

  Stream<OnboardingAnswer?> watch() {
    return _db.select(_db.onboardingAnswers).watchSingleOrNull();
  }

  Future<void> complete(String backgroundType) async {
    await _db.delete(_db.onboardingAnswers).go();
    await _db
        .into(_db.onboardingAnswers)
        .insert(
          OnboardingAnswersCompanion.insert(
            backgroundType: Value(backgroundType),
            completedAt: Value(DateTime.now()),
          ),
        );
  }
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(ref.watch(appDatabaseProvider));
});

final onboardingStatusProvider = StreamProvider<OnboardingAnswer?>((ref) {
  return ref.watch(onboardingRepositoryProvider).watch();
});
