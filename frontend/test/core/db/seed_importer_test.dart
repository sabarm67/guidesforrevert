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

    expect(stages, hasLength(9));
    expect(lessons, hasLength(132));
    expect(duas, hasLength(11));
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

    expect(lessons, hasLength(132));
    expect(faqs, hasLength(11));
    expect(surahs, hasLength(114));
    expect(ayahs, hasLength(6236));
  });

  test('removes a lesson row whose slug no longer exists in the bundled content', () async {
    // Simulates a device whose local DB still has a lesson from a slug
    // that has since been deleted from the content set entirely (e.g. two
    // lessons merged into one) -- upserting by slug alone would never
    // touch this row again, leaving it as a permanent ghost duplicate.
    final orphanLessonId = await db
        .into(db.lessons)
        .insert(
          LessonsCompanion.insert(
            learningStageId: 1,
            slug: 'a-slug-that-will-never-exist-in-bundled-content',
            order: 1,
            title: 'Orphaned Lesson',
            bodyJson: '[]',
          ),
        );
    await db
        .into(db.lessonProgressEntries)
        .insert(LessonProgressEntriesCompanion.insert(lessonId: orphanLessonId));

    await SeedImporter(db).importIfNeeded();

    final orphanLesson = await (db.select(
      db.lessons,
    )..where((t) => t.id.equals(orphanLessonId))).getSingleOrNull();
    final orphanProgress = await (db.select(
      db.lessonProgressEntries,
    )..where((t) => t.lessonId.equals(orphanLessonId))).getSingleOrNull();

    expect(orphanLesson, isNull);
    expect(orphanProgress, isNull);
  });

  test('records the imported content version', () async {
    await SeedImporter(db).importIfNeeded();

    final meta = await (db.select(
      db.contentVersionMeta,
    )..where((t) => t.contentType.equals('seed'))).getSingle();

    expect(meta.importedVersion, SeedImporter.currentContentVersion);
  });
}
