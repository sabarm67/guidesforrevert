import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'app_database.dart';

/// Imports the bundled `assets/content/*.json` files (synced from
/// `content/seed/` via scripts/sync-content) into the local Drift database
/// on first launch. Gated by [ContentVersionMeta] so re-imports don't
/// duplicate rows on every app start — see
/// docs/architecture/content-sync-and-versioning.md for the versioning
/// design this anticipates.
class SeedImporter {
  SeedImporter(this._db);

  final AppDatabase _db;

  /// Bumped whenever the bundled seed content changes in a way that needs
  /// re-import (e.g. new lessons added) — devices that already imported an
  /// older version will re-run the importer once and pick up the new rows.
  static const currentContentVersion = 6;

  Future<void> importIfNeeded() async {
    final meta = await (_db.select(
      _db.contentVersionMeta,
    )..where((t) => t.contentType.equals('seed'))).getSingleOrNull();

    if (meta != null && meta.importedVersion >= currentContentVersion) {
      return;
    }

    await _db.transaction(() async {
      await _importStagesAndLessons();
      await _importDuas();
      await _importAiFaq();

      await _db
          .into(_db.contentVersionMeta)
          .insertOnConflictUpdate(
            ContentVersionMetaCompanion.insert(
              contentType: 'seed',
              importedVersion: const Value(currentContentVersion),
            ),
          );
    });
  }

  Future<Map<String, dynamic>> _loadJson(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<List<dynamic>> _loadJsonList(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw) as List<dynamic>;
  }

  Future<void> _importStagesAndLessons() async {
    final stages = await _loadJsonList('assets/content/stages.json');

    for (final stageData in stages.cast<Map<String, dynamic>>()) {
      final companion = LearningStagesCompanion.insert(
        slug: stageData['slug'] as String,
        collectionType: Value(stageData['collection_type'] as String? ?? 'journey'),
        order: stageData['order'] as int,
        title: stageData['title'] as String,
        description: Value(stageData['description'] as String?),
        icon: Value(stageData['icon'] as String?),
      );

      // `slug`, not the autoincrement `id`, is the natural key here — the
      // default insertOnConflictUpdate() only targets the primary key,
      // which would never conflict on a fresh import and would raise a
      // UNIQUE constraint error on `slug` instead.
      await _db
          .into(_db.learningStages)
          .insert(companion, onConflict: DoUpdate((_) => companion, target: [_db.learningStages.slug]));
    }

    final lessonAssetPaths = [
      'assets/content/lessons/stage1-lesson1-who-is-allah.json',
      'assets/content/lessons/stage1-lesson2-the-shahada.json',
      'assets/content/lessons/stage1-lesson3-what-is-the-quran.json',
      'assets/content/lessons/stage1-lesson4-who-was-muhammad.json',
      'assets/content/lessons/stage2-lesson1-cleanliness-and-purity.json',
      'assets/content/lessons/stage2-lesson2-understanding-the-azan.json',
      'assets/content/lessons/stage2-lesson3-learning-wudu.json',
      'assets/content/lessons/stage2-lesson4-learning-salah.json',
      'assets/content/lessons/stage2-lesson5-entering-the-mosque.json',
      'assets/content/lessons/stage2-lesson6-islamic-greetings.json',
      'assets/content/lessons/stage2-lesson7-arabic-pronunciation.json',
      'assets/content/lessons/stage2-lesson8-basic-duas-for-daily-life.json',
      'assets/content/lessons/stage3-lesson1-making-daily-prayers-a-habit.json',
      'assets/content/lessons/stage3-lesson2-engaging-with-the-quran-daily.json',
      'assets/content/lessons/stage3-lesson3-dhikr-remembrance-of-allah.json',
      'assets/content/lessons/stage3-lesson4-good-manners-akhlaq.json',
      'assets/content/lessons/stage3-lesson5-family-in-islam.json',
      'assets/content/lessons/stage3-lesson6-food-and-halal.json',
      'assets/content/lessons/stage3-lesson7-islam-at-work.json',
      'assets/content/lessons/stage3-lesson8-charity-and-zakat.json',
      'assets/content/lessons/stage4-lesson1-seerah-the-life-of-the-prophet.json',
      'assets/content/lessons/stage4-lesson2-the-companions-sahabah.json',
      'assets/content/lessons/stage4-lesson3-islamic-history-overview.json',
      'assets/content/lessons/stage4-lesson4-understanding-madhhabs.json',
      'assets/content/lessons/stage4-lesson5-islamic-civilisation.json',
      'assets/content/lessons/stage4-lesson6-islamic-ethics.json',
      'assets/content/lessons/stage4-lesson7-marriage-in-islam.json',
      'assets/content/lessons/stage4-lesson8-islamic-finance.json',
      'assets/content/lessons/stage4-lesson9-building-community.json',
      'assets/content/lessons/fiqh-lesson1-what-is-fiqh.json',
      'assets/content/lessons/fiqh-lesson2-halal-earning-business-ethics.json',
      'assets/content/lessons/fiqh-lesson3-marriage-divorce-fiqh.json',
      'assets/content/lessons/fiqh-lesson4-inheritance-basics.json',
      'assets/content/lessons/fiqh-lesson5-food-dress-in-depth.json',
      'assets/content/lessons/fiqh-lesson6-social-dealings-and-rights.json',
      'assets/content/lessons/fiqh-lesson7-living-under-secular-law.json',
      'assets/content/lessons/fiqh-lesson8-contemporary-issues.json',
      'assets/content/lessons/fiqh-lesson9-navigating-fiqh-differences.json',
      'assets/content/lessons/misconceptions-lesson1-is-islam-violent.json',
      'assets/content/lessons/misconceptions-lesson2-what-does-jihad-mean.json',
      'assets/content/lessons/misconceptions-lesson3-does-islam-oppress-women.json',
      'assets/content/lessons/misconceptions-lesson4-spread-by-the-sword.json',
      'assets/content/lessons/misconceptions-lesson5-what-is-sharia-law.json',
      'assets/content/lessons/misconceptions-lesson6-view-of-other-faiths.json',
      'assets/content/lessons/misconceptions-lesson7-polygamy-context-rules.json',
      'assets/content/lessons/misconceptions-lesson8-honor-killing-fgm-culture-vs-religion.json',
      'assets/content/lessons/misconceptions-lesson9-secular-democracy.json',
      'assets/content/lessons/misconceptions-lesson10-fear-of-hearing-azan.json',
      'assets/content/lessons/misconceptions-lesson11-praying-in-public.json',
      'assets/content/lessons/misconceptions-lesson12-fear-of-the-quran.json',
      'assets/content/lessons/misconceptions-lesson13-halal-slaughter-cruelty.json',
      'assets/content/lessons/misconceptions-lesson14-hijab-niqab-security-fears.json',
      'assets/content/lessons/misconceptions-lesson15-why-beards.json',
      'assets/content/lessons/misconceptions-lesson16-facing-mecca-idol-worship.json',
      'assets/content/lessons/misconceptions-lesson17-mosques-recruiting-grounds.json',
      'assets/content/lessons/misconceptions-lesson18-why-arabic.json',
      'assets/content/lessons/misconceptions-lesson19-ramadan-fasting-extreme.json',
      'assets/content/lessons/misconceptions-lesson20-changing-your-name.json',
      'assets/content/lessons/misconceptions-lesson21-cutting-off-non-muslim-friends.json',
      'assets/content/lessons/misconceptions-lesson22-islam-view-of-jesus.json',
      'assets/content/lessons/misconceptions-lesson23-view-of-bible-torah.json',
      'assets/content/lessons/misconceptions-lesson24-ummah-divided-loyalty.json',
      'assets/content/lessons/misconceptions-lesson25-dawah-aggressive-proselytizing.json',
      'assets/content/lessons/misconceptions-lesson26-apostasy-leaving-islam.json',
      'assets/content/lessons/misconceptions-lesson27-child-marriage.json',
      'assets/content/lessons/misconceptions-lesson28-muslims-and-dogs.json',
      'assets/content/lessons/misconceptions-lesson29-art-and-images.json',
      'assets/content/lessons/misconceptions-lesson30-slavery-in-islamic-history.json',
      'assets/content/lessons/misconceptions-lesson31-science-and-evolution.json',
    ];

    for (final path in lessonAssetPaths) {
      final lessonData = await _loadJson(path);

      final stage = await (_db.select(
        _db.learningStages,
      )..where((t) => t.slug.equals(lessonData['stage_slug'] as String))).getSingleOrNull();

      if (stage == null) continue;

      final companion = LessonsCompanion.insert(
        learningStageId: stage.id,
        slug: lessonData['slug'] as String,
        order: lessonData['order'] as int,
        title: lessonData['title'] as String,
        summary: Value(lessonData['summary'] as String?),
        bodyJson: jsonEncode(lessonData['body']),
        estimatedMinutes: Value(lessonData['estimated_minutes'] as int? ?? 5),
        needToKnow: Value(lessonData['need_to_know'] as bool? ?? true),
      );

      await _db
          .into(_db.lessons)
          .insert(companion, onConflict: DoUpdate((_) => companion, target: [_db.lessons.slug]));
    }
  }

  Future<void> _importDuas() async {
    final duas = await _loadJsonList('assets/content/duas.json');

    const categoryTitles = {
      'morning-evening': 'Morning & Evening',
      'eating': 'Eating & Drinking',
      'distress-and-difficulty': 'Distress & Difficulty',
      'entering-leaving-home': 'Entering & Leaving Home',
    };

    final categoryOrder = <String, int>{};

    for (final duaData in duas.cast<Map<String, dynamic>>()) {
      final slug = duaData['category_slug'] as String;
      categoryOrder.putIfAbsent(slug, () => categoryOrder.length + 1);

      final categoryCompanion = DuaCategoriesCompanion.insert(
        slug: slug,
        title: categoryTitles[slug] ?? slug,
        order: categoryOrder[slug]!,
      );

      await _db
          .into(_db.duaCategories)
          .insert(
            categoryCompanion,
            onConflict: DoUpdate((_) => categoryCompanion, target: [_db.duaCategories.slug]),
          );

      final category = await (_db.select(_db.duaCategories)..where((t) => t.slug.equals(slug))).getSingle();

      await _db
          .into(_db.duas)
          .insertOnConflictUpdate(
            DuasCompanion.insert(
              duaCategoryId: category.id,
              title: duaData['title'] as String,
              arabicText: duaData['arabic_text'] as String,
              transliteration: duaData['transliteration'] as String,
              translation: duaData['translation'] as String,
              reference: duaData['reference'] as String,
              authenticity: Value(duaData['authenticity'] as String? ?? 'sahih'),
              benefits: Value(duaData['benefits'] as String?),
              isDailyFeatured: Value(duaData['is_daily_featured'] as bool? ?? false),
              order: duaData['order'] as int? ?? 1,
            ),
          );
    }
  }

  Future<void> _importAiFaq() async {
    final entries = await _loadJsonList('assets/content/ai-mentor-faq.json');

    for (final entry in entries.cast<Map<String, dynamic>>()) {
      final companion = AiFaqEntriesCompanion.insert(
        faqKey: entry['id'] as String,
        canonicalQuestion: entry['canonical_question'] as String,
        questionVariantsJson: jsonEncode(entry['question_variants']),
        keywordsJson: jsonEncode(entry['keywords']),
        category: entry['category'] as String,
        answerText: entry['answer_text'] as String,
        sourceCitationsJson: jsonEncode(entry['source_citations']),
        confidence: entry['confidence'] as String,
        requiresScholarDisclaimer: Value(entry['requires_scholar_disclaimer'] as bool? ?? false),
      );

      await _db
          .into(_db.aiFaqEntries)
          .insert(companion, onConflict: DoUpdate((_) => companion, target: [_db.aiFaqEntries.faqKey]));
    }
  }
}
