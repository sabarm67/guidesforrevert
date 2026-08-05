import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_muslim_companion/core/db/app_database.dart';
import 'package:new_muslim_companion/core/db/seed_importer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('imports the bundled seed content into the local database', () async {
    await SeedImporter(db).importIfNeeded();

    final stages = await db.select(db.learningStages).get();
    final lessons = await db.select(db.lessons).get();
    final duas = await db.select(db.duas).get();
    final faqs = await db.select(db.aiFaqEntries).get();
    final surahs = await db.select(db.surahs).get();
    final ayahs = await db.select(db.ayahs).get();

    expect(stages, hasLength(8));
    expect(lessons, hasLength(122));
    expect(duas, hasLength(6));
    expect(faqs, isNotEmpty);
    expect(surahs, hasLength(114));
    expect(ayahs, hasLength(6236));
  });

  test('does not duplicate rows when imported twice', () async {
    final importer = SeedImporter(db);

    await importer.importIfNeeded();
    await importer.importIfNeeded();

    final lessons = await db.select(db.lessons).get();
    final faqs = await db.select(db.aiFaqEntries).get();
    final surahs = await db.select(db.surahs).get();
    final ayahs = await db.select(db.ayahs).get();

    expect(lessons, hasLength(122));
    expect(faqs, hasLength(11));
    expect(surahs, hasLength(114));
    expect(ayahs, hasLength(6236));
  });

  test('records the imported content version', () async {
    await SeedImporter(db).importIfNeeded();

    final meta = await (db.select(
      db.contentVersionMeta,
    )..where((t) => t.contentType.equals('seed'))).getSingle();

    expect(meta.importedVersion, SeedImporter.currentContentVersion);
  });
}
