import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';

/// Mirrors the backend's `DailyDuaSelector` exactly (dayOfYear % count over
/// the featured set) so the offline client and the optional online API
/// never disagree about which dua is "today's dua" — see
/// docs/api/api-notes.md.
class DailyDuaRepository {
  DailyDuaRepository(this._db);

  final AppDatabase _db;

  Future<Dua?> today({DateTime? date}) async {
    final featured =
        await (_db.select(_db.duas)
              ..where((t) => t.isDailyFeatured.equals(true))
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();

    if (featured.isEmpty) return null;

    final d = date ?? DateTime.now();
    final dayOfYear = DateTime(d.year, d.month, d.day).difference(DateTime(d.year, 1, 1)).inDays + 1;
    final index = dayOfYear % featured.length;

    return featured[index];
  }
}

final dailyDuaRepositoryProvider = Provider<DailyDuaRepository>((ref) {
  return DailyDuaRepository(ref.watch(appDatabaseProvider));
});

final dailyDuaProvider = FutureProvider<Dua?>((ref) {
  return ref.watch(dailyDuaRepositoryProvider).today();
});
