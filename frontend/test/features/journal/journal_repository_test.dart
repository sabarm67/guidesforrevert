import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_muslim_companion/core/db/app_database.dart';
import 'package:new_muslim_companion/features/journal/journal_repository.dart';

void main() {
  late AppDatabase db;
  late JournalRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = JournalRepository(db);
  });

  tearDown(() => db.close());

  test('creates an entry and it appears in watchEntries', () async {
    await repository.createEntry(title: 'First reflection', body: 'Alhamdulillah for today.');

    final entries = await repository.watchEntries().first;

    expect(entries, hasLength(1));
    expect(entries.first.title, 'First reflection');
    expect(entries.first.body, 'Alhamdulillah for today.');
    expect(entries.first.updatedAt, isNull);
  });

  test('supports entries with no title', () async {
    await repository.createEntry(body: 'Just some thoughts.');

    final entries = await repository.watchEntries().first;

    expect(entries.first.title, isNull);
  });

  test('updateEntry changes body/title and sets updatedAt', () async {
    final id = await repository.createEntry(title: 'Original', body: 'Original body');

    await repository.updateEntry(id, title: 'Edited', body: 'Edited body');

    final entry = await repository.entryById(id);
    expect(entry!.title, 'Edited');
    expect(entry.body, 'Edited body');
    expect(entry.updatedAt, isNotNull);
  });

  test('deleteEntry removes it from watchEntries', () async {
    final id = await repository.createEntry(body: 'To be deleted');

    await repository.deleteEntry(id);

    final entries = await repository.watchEntries().first;
    expect(entries, isEmpty);
  });

  test('watchEntries orders newest first', () async {
    final olderId = await db
        .into(db.journalEntries)
        .insert(
          JournalEntriesCompanion.insert(
            body: 'Older',
            createdAt: Value(DateTime(2026, 1, 1)),
          ),
        );
    await db
        .into(db.journalEntries)
        .insert(
          JournalEntriesCompanion.insert(
            body: 'Newer',
            createdAt: Value(DateTime(2026, 1, 2)),
          ),
        );

    final entries = await repository.watchEntries().first;

    expect(entries.first.body, 'Newer');
    expect(entries.last.id, olderId);
  });
}
