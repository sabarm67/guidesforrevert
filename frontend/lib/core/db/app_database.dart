import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Mirrors the backend's `learning_stages` table (see
/// docs/architecture/er-diagram.md) — this is the on-device copy imported
/// from the bundled content, not a live connection to the backend.
class LearningStages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get slug => text().unique()();

  /// 'journey' (the 4 linear stages) or a standalone topic collection like
  /// 'fiqh'/'misconceptions' — see LearningRepository.watchStagesByCollection.
  TextColumn get collectionType => text().withDefault(const Constant('journey'))();
  IntColumn get order => integer()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().nullable()();
}

class Lessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get learningStageId => integer().references(LearningStages, #id)();
  TextColumn get slug => text().unique()();
  IntColumn get order => integer()();
  TextColumn get title => text()();
  TextColumn get summary => text().nullable()();

  /// JSON-encoded array of structured content blocks (heading/text/quote/...).
  TextColumn get bodyJson => text()();
  IntColumn get estimatedMinutes => integer().withDefault(const Constant(5))();
  BoolColumn get needToKnow => boolean().withDefault(const Constant(true))();
}

class LessonProgressEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId => integer().references(Lessons, #id)();

  /// One of: not_started, in_progress, completed.
  TextColumn get status => text().withDefault(const Constant('not_started'))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {lessonId},
  ];
}

class DuaCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get slug => text().unique()();
  TextColumn get title => text()();
  TextColumn get icon => text().nullable()();
  IntColumn get order => integer()();
}

class Duas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get duaCategoryId => integer().references(DuaCategories, #id)();
  TextColumn get title => text()();
  TextColumn get arabicText => text()();
  TextColumn get transliteration => text()();
  TextColumn get translation => text()();
  TextColumn get reference => text()();
  TextColumn get authenticity => text().withDefault(const Constant('sahih'))();
  TextColumn get benefits => text().nullable()();
  BoolColumn get isDailyFeatured => boolean().withDefault(const Constant(false))();
  IntColumn get order => integer()();
}

class AiFaqEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get faqKey => text().unique()();
  TextColumn get canonicalQuestion => text()();

  /// JSON-encoded array of strings.
  TextColumn get questionVariantsJson => text()();

  /// JSON-encoded array of strings.
  TextColumn get keywordsJson => text()();
  TextColumn get category => text()();
  TextColumn get answerText => text()();

  /// JSON-encoded array of {type, id?, collection?, number?, label}.
  TextColumn get sourceCitationsJson => text()();

  /// One of: general_guidance, requires_scholar.
  TextColumn get confidence => text()();
  BoolColumn get requiresScholarDisclaimer => boolean().withDefault(const Constant(false))();
}

/// Single-row table holding the local device's onboarding answer — there is
/// no multi-user account system in the offline-first core experience.
class OnboardingAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get backgroundType => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

/// Tracks which version of each bundled content type has been imported, so
/// `SeedImporter` only imports once per version (see
/// docs/architecture/content-sync-and-versioning.md).
class ContentVersionMeta extends Table {
  TextColumn get contentType => text()();
  IntColumn get importedVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {contentType};
}

/// A user's private reflections/journal entries — local-only in this phase
/// (no backend sync), matching the offline-first default for anything that
/// isn't shared, bundled content.
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  TextColumn get body => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

@DriftDatabase(
  tables: [
    LearningStages,
    Lessons,
    LessonProgressEntries,
    DuaCategories,
    Duas,
    AiFaqEntries,
    OnboardingAnswers,
    ContentVersionMeta,
    JournalEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(journalEntries);
      }
      if (from < 3) {
        await m.addColumn(learningStages, learningStages.collectionType);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'new_muslim_companion',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
