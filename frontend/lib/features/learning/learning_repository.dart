import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';

class LessonWithStage {
  const LessonWithStage({required this.lesson, required this.stage});

  final Lesson lesson;
  final LearningStage stage;
}

/// The single "what should I do next" pointer for the Home dashboard: the
/// first not-completed lesson in stage/lesson order, or null if every
/// bundled lesson is complete.
class ContinueLearningTarget {
  const ContinueLearningTarget({required this.lesson, required this.stage, required this.isNewLesson});

  final Lesson lesson;
  final LearningStage stage;

  /// False when every lesson is complete and this is just re-offering the
  /// last lesson rather than pointing at genuinely new content.
  final bool isNewLesson;
}

class LearningRepository {
  LearningRepository(this._db);

  final AppDatabase _db;

  /// The 4 linear Learning Journey stages specifically — excludes standalone
  /// topic collections like Fiqh in Daily Life, which have their own
  /// `collection_type` and are queried separately via
  /// [watchStagesByCollection].
  Stream<List<LearningStage>> watchStages() {
    return (_db.select(_db.learningStages)
          ..where((t) => t.collectionType.equals('journey'))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .watch();
  }

  /// Stages/collections outside the linear Learning Journey — e.g. 'fiqh'
  /// or 'misconceptions' — each collection currently has a single stage
  /// row, but this supports more than one per collection if that changes.
  Stream<List<LearningStage>> watchStagesByCollection(String collectionType) {
    return (_db.select(_db.learningStages)
          ..where((t) => t.collectionType.equals(collectionType))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .watch();
  }

  Stream<List<Lesson>> watchLessonsForStage(int stageId) {
    return (_db.select(_db.lessons)
          ..where((t) => t.learningStageId.equals(stageId))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .watch();
  }

  Future<Lesson?> lessonById(int id) {
    return (_db.select(_db.lessons)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  List<Map<String, dynamic>> decodeBody(Lesson lesson) {
    return (jsonDecode(lesson.bodyJson) as List).cast<Map<String, dynamic>>();
  }

  Stream<LessonProgressEntry?> watchProgress(int lessonId) {
    return (_db.select(
      _db.lessonProgressEntries,
    )..where((t) => t.lessonId.equals(lessonId))).watchSingleOrNull();
  }

  /// Streams (completedCount, totalCount) for a stage's lessons, used to show
  /// a per-stage progress indicator on the roadmap.
  Stream<(int, int)> watchStageProgress(int stageId) {
    final query = _db.select(_db.lessons).join([
      leftOuterJoin(_db.lessonProgressEntries, _db.lessonProgressEntries.lessonId.equalsExp(_db.lessons.id)),
    ])..where(_db.lessons.learningStageId.equals(stageId));

    return query.watch().map((rows) {
      final completed = rows.where((row) {
        final progress = row.readTableOrNull(_db.lessonProgressEntries);
        return progress?.status == 'completed';
      }).length;

      return (completed, rows.length);
    });
  }

  Future<void> markLessonStatus(int lessonId, String status) async {
    await _db
        .into(_db.lessonProgressEntries)
        .insertOnConflictUpdate(
          LessonProgressEntriesCompanion.insert(
            lessonId: lessonId,
            status: Value(status),
            completedAt: Value(status == 'completed' ? DateTime.now() : null),
          ),
        );
  }

  /// Streams the first not-completed lesson across all stages, in
  /// (stage.order, lesson.order) sequence — this is what "Continue
  /// Learning" on the Home dashboard points to.
  Stream<ContinueLearningTarget?> watchContinueLearningTarget() {
    final query = _db.select(_db.lessons).join([
      innerJoin(_db.learningStages, _db.learningStages.id.equalsExp(_db.lessons.learningStageId)),
      leftOuterJoin(_db.lessonProgressEntries, _db.lessonProgressEntries.lessonId.equalsExp(_db.lessons.id)),
    ])
      ..where(_db.learningStages.collectionType.equals('journey'))
      ..orderBy([OrderingTerm.asc(_db.learningStages.order), OrderingTerm.asc(_db.lessons.order)]);

    return query.watch().map((rows) {
      if (rows.isEmpty) return null;

      for (final row in rows) {
        final progress = row.readTableOrNull(_db.lessonProgressEntries);
        if (progress == null || progress.status != 'completed') {
          return ContinueLearningTarget(
            lesson: row.readTable(_db.lessons),
            stage: row.readTable(_db.learningStages),
            isNewLesson: true,
          );
        }
      }

      // Everything is complete — re-offer the very first lesson.
      final first = rows.first;
      return ContinueLearningTarget(
        lesson: first.readTable(_db.lessons),
        stage: first.readTable(_db.learningStages),
        isNewLesson: false,
      );
    });
  }
}

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  return LearningRepository(ref.watch(appDatabaseProvider));
});

final continueLearningProvider = StreamProvider<ContinueLearningTarget?>((ref) {
  return ref.watch(learningRepositoryProvider).watchContinueLearningTarget();
});
