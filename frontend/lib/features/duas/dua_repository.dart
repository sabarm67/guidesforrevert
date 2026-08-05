import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';

class DuaRepository {
  DuaRepository(this._db);

  final AppDatabase _db;

  Stream<List<DuaCategory>> watchCategories() {
    return (_db.select(_db.duaCategories)..orderBy([(t) => OrderingTerm.asc(t.order)])).watch();
  }

  Stream<List<Dua>> watchDuasForCategory(int categoryId) {
    return (_db.select(_db.duas)
          ..where((t) => t.duaCategoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .watch();
  }
}

final duaRepositoryProvider = Provider<DuaRepository>((ref) {
  return DuaRepository(ref.watch(appDatabaseProvider));
});
