import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';

class JournalRepository {
  JournalRepository(this._db);

  final AppDatabase _db;

  Stream<List<JournalEntry>> watchEntries() {
    return (_db.select(
      _db.journalEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Future<JournalEntry?> entryById(int id) {
    return (_db.select(_db.journalEntries)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> createEntry({String? title, required String body}) {
    return _db
        .into(_db.journalEntries)
        .insert(JournalEntriesCompanion.insert(title: Value(title), body: body));
  }

  Future<void> updateEntry(int id, {String? title, required String body}) {
    return (_db.update(_db.journalEntries)..where((t) => t.id.equals(id))).write(
      JournalEntriesCompanion(title: Value(title), body: Value(body), updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteEntry(int id) {
    return (_db.delete(_db.journalEntries)..where((t) => t.id.equals(id))).go();
  }
}

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(ref.watch(appDatabaseProvider));
});
