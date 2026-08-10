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
  static const currentContentVersion = 17;

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
      await _importQuran();

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
      'assets/content/lessons/stage1-lesson3-the-five-pillars-of-islam.json',
      'assets/content/lessons/stage1-lesson4-the-six-articles-of-faith.json',
      'assets/content/lessons/stage1-lesson5-what-is-the-quran.json',
      'assets/content/lessons/stage1-lesson6-who-was-muhammad.json',
      'assets/content/lessons/stage1-lesson7-what-are-hadith-and-sunnah.json',
      'assets/content/lessons/prayer-lesson1-how-to-perform-wudu.json',
      'assets/content/lessons/prayer-lesson2-how-to-pray-salah.json',
      'assets/content/lessons/prayer-lesson3-types-of-prayer.json',
      'assets/content/lessons/prayer-lesson4-how-to-perform-ghusl.json',
      'assets/content/lessons/stage2-lesson1-cleanliness-and-purity.json',
      'assets/content/lessons/stage2-lesson10-categories-of-water.json',
      'assets/content/lessons/stage2-lesson2-understanding-the-azan.json',
      'assets/content/lessons/stage2-lesson3-learning-wudu.json',
      'assets/content/lessons/stage2-lesson9-learning-ghusl.json',
      'assets/content/lessons/stage2-lesson4-learning-salah.json',
      'assets/content/lessons/stage2-lesson5-entering-the-mosque.json',
      'assets/content/lessons/stage2-lesson6-islamic-greetings.json',
      'assets/content/lessons/stage2-lesson7-arabic-pronunciation.json',
      'assets/content/lessons/stage2-lesson8-basic-duas-for-daily-life.json',
      'assets/content/lessons/stage2-lesson11-hukm-taklifi.json',
      'assets/content/lessons/stage2-lesson12-halal-and-haram.json',
      'assets/content/lessons/stage2-lesson13-hukm-wadhi.json',
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
      'assets/content/lessons/compare-christianity-lesson1-shared-prophets.json',
      'assets/content/lessons/compare-christianity-lesson2-one-creator-god.json',
      'assets/content/lessons/compare-christianity-lesson3-jesus-in-the-quran.json',
      'assets/content/lessons/compare-christianity-lesson4-mary-in-islam.json',
      'assets/content/lessons/compare-christianity-lesson5-shared-moral-ground.json',
      'assets/content/lessons/compare-christianity-lesson6-tawhid-vs-trinity.json',
      'assets/content/lessons/compare-christianity-lesson7-is-jesus-son-of-god.json',
      'assets/content/lessons/compare-christianity-lesson8-holy-spirit-in-islam.json',
      'assets/content/lessons/compare-christianity-lesson9-history-of-the-trinity.json',
      'assets/content/lessons/compare-christianity-lesson10-divine-transcendence.json',
      'assets/content/lessons/compare-christianity-lesson11-did-jesus-die-on-cross.json',
      'assets/content/lessons/compare-christianity-lesson12-jesus-alive-and-will-return.json',
      'assets/content/lessons/compare-christianity-lesson13-no-original-sin.json',
      'assets/content/lessons/compare-christianity-lesson14-salvation-without-atonement.json',
      'assets/content/lessons/compare-christianity-lesson15-faith-works-and-grace.json',
      'assets/content/lessons/compare-christianity-lesson16-is-islam-works-based.json',
      'assets/content/lessons/compare-christianity-lesson17-bible-and-quran-preservation.json',
      'assets/content/lessons/compare-christianity-lesson18-did-bible-predict-muhammad.json',
      'assets/content/lessons/compare-christianity-lesson19-why-muslims-believe-tahrif.json',
      'assets/content/lessons/compare-christianity-lesson20-old-testament-law-and-sharia.json',
      'assets/content/lessons/compare-christianity-lesson21-injil-vs-new-testament.json',
      'assets/content/lessons/compare-christianity-lesson22-how-each-faith-reads-scripture.json',
      'assets/content/lessons/compare-christianity-lesson23-church-and-mosque.json',
      'assets/content/lessons/compare-christianity-lesson24-why-no-clergy.json',
      'assets/content/lessons/compare-christianity-lesson25-confession-and-repentance.json',
      'assets/content/lessons/compare-christianity-lesson26-baptism-and-communion.json',
      'assets/content/lessons/compare-christianity-lesson27-sunday-vs-jumuah.json',
      'assets/content/lessons/compare-christianity-lesson28-lent-and-ramadan.json',
      'assets/content/lessons/compare-christianity-lesson29-tithing-and-zakat.json',
      'assets/content/lessons/compare-christianity-lesson30-no-rites-of-passage.json',
      'assets/content/lessons/compare-christianity-lesson31-alcohol.json',
      'assets/content/lessons/compare-christianity-lesson32-modesty-compared.json',
      'assets/content/lessons/compare-christianity-lesson33-marriage-divorce-family.json',
      'assets/content/lessons/compare-christianity-lesson34-monasticism.json',
      'assets/content/lessons/compare-christianity-lesson35-sabbath-rest.json',
      'assets/content/lessons/compare-christianity-lesson36-clergy-celibacy.json',
      'assets/content/lessons/compare-christianity-lesson37-evangelism-and-dawah.json',
      'assets/content/lessons/compare-christianity-lesson38-christianity-isnt-one-thing.json',
      'assets/content/lessons/compare-christianity-lesson39-sola-scriptura-and-quran-finality.json',
      'assets/content/lessons/compare-christianity-lesson40-purgatory.json',
      'assets/content/lessons/compare-christianity-lesson41-predestination.json',
      'assets/content/lessons/compare-christianity-lesson42-new-testament-only-confusions.json',
      'assets/content/lessons/compare-christianity-lesson43-telling-christian-family.json',
      'assets/content/lessons/compare-christianity-lesson44-dont-you-believe-in-jesus.json',
      'assets/content/lessons/compare-christianity-lesson45-christmas-easter-holidays.json',
      'assets/content/lessons/compare-christianity-lesson46-grief-guilt-and-growth.json',
      'assets/content/lessons/compare-christianity-lesson47-common-questions-family-will-ask.json',
      'assets/content/lessons/compare-christianity-lesson48-finding-common-ground.json',
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
      'trials-of-a-new-muslim': 'Trials as a New Muslim',
      'patience': 'Patience',
      'fairness-and-character': 'Fairness & Good Character',
      'good-deeds': 'Good Deeds',
      'parents': 'For Parents',
    };

    // Duas has no natural unique key to upsert against (unlike lessons'
    // slug or learningStages' slug), so `insertOnConflictUpdate()` — which
    // only ever targets the primary key — could never actually find a
    // conflict on a fresh autoincrement id. That silently turned every
    // re-import (each content-version bump) into an append rather than an
    // update, leaving duplicate rows behind. Clearing both tables first
    // sidesteps the missing-unique-key problem entirely: duas are fully
    // bundled, read-only content with no user data attached, so a clean
    // delete-then-reinsert is safe and simpler than retrofitting a unique
    // constraint via a schema migration.
    await _db.delete(_db.duas).go();
    await _db.delete(_db.duaCategories).go();

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
          .insert(
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

  /// The full 114-surah Quran (Tanzil Arabic text, Pickthall public-domain
  /// English translation — see content/seed/SOURCES.md), authored via
  /// `php artisan quran:import` into `content/seed/quran/*.json`.
  static const _surahAssetPaths = [
    'assets/content/quran/surah-001-al-fatihah.json',
    'assets/content/quran/surah-002-al-baqarah.json',
    'assets/content/quran/surah-003-ali-imran.json',
    'assets/content/quran/surah-004-an-nisa.json',
    'assets/content/quran/surah-005-al-maidah.json',
    'assets/content/quran/surah-006-al-anam.json',
    'assets/content/quran/surah-007-al-araf.json',
    'assets/content/quran/surah-008-al-anfal.json',
    'assets/content/quran/surah-009-at-tawbah.json',
    'assets/content/quran/surah-010-yunus.json',
    'assets/content/quran/surah-011-hud.json',
    'assets/content/quran/surah-012-yusuf.json',
    'assets/content/quran/surah-013-ar-rad.json',
    'assets/content/quran/surah-014-ibrahim.json',
    'assets/content/quran/surah-015-al-hijr.json',
    'assets/content/quran/surah-016-an-nahl.json',
    'assets/content/quran/surah-017-al-isra.json',
    'assets/content/quran/surah-018-al-kahf.json',
    'assets/content/quran/surah-019-maryam.json',
    'assets/content/quran/surah-020-taha.json',
    'assets/content/quran/surah-021-al-anbya.json',
    'assets/content/quran/surah-022-al-hajj.json',
    'assets/content/quran/surah-023-al-muminun.json',
    'assets/content/quran/surah-024-an-nur.json',
    'assets/content/quran/surah-025-al-furqan.json',
    'assets/content/quran/surah-026-ash-shuara.json',
    'assets/content/quran/surah-027-an-naml.json',
    'assets/content/quran/surah-028-al-qasas.json',
    'assets/content/quran/surah-029-al-ankabut.json',
    'assets/content/quran/surah-030-ar-rum.json',
    'assets/content/quran/surah-031-luqman.json',
    'assets/content/quran/surah-032-as-sajdah.json',
    'assets/content/quran/surah-033-al-ahzab.json',
    'assets/content/quran/surah-034-saba.json',
    'assets/content/quran/surah-035-fatir.json',
    'assets/content/quran/surah-036-ya-sin.json',
    'assets/content/quran/surah-037-as-saffat.json',
    'assets/content/quran/surah-038-sad.json',
    'assets/content/quran/surah-039-az-zumar.json',
    'assets/content/quran/surah-040-ghafir.json',
    'assets/content/quran/surah-041-fussilat.json',
    'assets/content/quran/surah-042-ash-shuraa.json',
    'assets/content/quran/surah-043-az-zukhruf.json',
    'assets/content/quran/surah-044-ad-dukhan.json',
    'assets/content/quran/surah-045-al-jathiyah.json',
    'assets/content/quran/surah-046-al-ahqaf.json',
    'assets/content/quran/surah-047-muhammad.json',
    'assets/content/quran/surah-048-al-fath.json',
    'assets/content/quran/surah-049-al-hujurat.json',
    'assets/content/quran/surah-050-qaf.json',
    'assets/content/quran/surah-051-adh-dhariyat.json',
    'assets/content/quran/surah-052-at-tur.json',
    'assets/content/quran/surah-053-an-najm.json',
    'assets/content/quran/surah-054-al-qamar.json',
    'assets/content/quran/surah-055-ar-rahman.json',
    'assets/content/quran/surah-056-al-waqiah.json',
    'assets/content/quran/surah-057-al-hadid.json',
    'assets/content/quran/surah-058-al-mujadila.json',
    'assets/content/quran/surah-059-al-hashr.json',
    'assets/content/quran/surah-060-al-mumtahanah.json',
    'assets/content/quran/surah-061-as-saf.json',
    'assets/content/quran/surah-062-al-jumuah.json',
    'assets/content/quran/surah-063-al-munafiqun.json',
    'assets/content/quran/surah-064-at-taghabun.json',
    'assets/content/quran/surah-065-at-talaq.json',
    'assets/content/quran/surah-066-at-tahrim.json',
    'assets/content/quran/surah-067-al-mulk.json',
    'assets/content/quran/surah-068-al-qalam.json',
    'assets/content/quran/surah-069-al-haqqah.json',
    'assets/content/quran/surah-070-al-maarij.json',
    'assets/content/quran/surah-071-nuh.json',
    'assets/content/quran/surah-072-al-jinn.json',
    'assets/content/quran/surah-073-al-muzzammil.json',
    'assets/content/quran/surah-074-al-muddaththir.json',
    'assets/content/quran/surah-075-al-qiyamah.json',
    'assets/content/quran/surah-076-al-insan.json',
    'assets/content/quran/surah-077-al-mursalat.json',
    'assets/content/quran/surah-078-an-naba.json',
    'assets/content/quran/surah-079-an-naziat.json',
    'assets/content/quran/surah-080-abasa.json',
    'assets/content/quran/surah-081-at-takwir.json',
    'assets/content/quran/surah-082-al-infitar.json',
    'assets/content/quran/surah-083-al-mutaffifin.json',
    'assets/content/quran/surah-084-al-inshiqaq.json',
    'assets/content/quran/surah-085-al-buruj.json',
    'assets/content/quran/surah-086-at-tariq.json',
    'assets/content/quran/surah-087-al-ala.json',
    'assets/content/quran/surah-088-al-ghashiyah.json',
    'assets/content/quran/surah-089-al-fajr.json',
    'assets/content/quran/surah-090-al-balad.json',
    'assets/content/quran/surah-091-ash-shams.json',
    'assets/content/quran/surah-092-al-layl.json',
    'assets/content/quran/surah-093-ad-duhaa.json',
    'assets/content/quran/surah-094-ash-sharh.json',
    'assets/content/quran/surah-095-at-tin.json',
    'assets/content/quran/surah-096-al-alaq.json',
    'assets/content/quran/surah-097-al-qadr.json',
    'assets/content/quran/surah-098-al-bayyinah.json',
    'assets/content/quran/surah-099-az-zalzalah.json',
    'assets/content/quran/surah-100-al-adiyat.json',
    'assets/content/quran/surah-101-al-qariah.json',
    'assets/content/quran/surah-102-at-takathur.json',
    'assets/content/quran/surah-103-al-asr.json',
    'assets/content/quran/surah-104-al-humazah.json',
    'assets/content/quran/surah-105-al-fil.json',
    'assets/content/quran/surah-106-quraysh.json',
    'assets/content/quran/surah-107-al-maun.json',
    'assets/content/quran/surah-108-al-kawthar.json',
    'assets/content/quran/surah-109-al-kafirun.json',
    'assets/content/quran/surah-110-an-nasr.json',
    'assets/content/quran/surah-111-al-masad.json',
    'assets/content/quran/surah-112-al-ikhlas.json',
    'assets/content/quran/surah-113-al-falaq.json',
    'assets/content/quran/surah-114-an-nas.json',
  ];

  /// Loads and parses all 114 bundled surah files once, ahead of either
  /// import path below. Loaded concurrently rather than one at a time —
  /// 114 sequential awaited asset reads adds up to a noticeably slower
  /// first launch (and, in widget tests, can outrun a bounded pump-count
  /// settle loop).
  Future<List<Map<String, dynamic>>> _loadAllSurahData() async {
    return Future.wait(_surahAssetPaths.map(_loadJson));
  }

  /// 114 surahs / 6,236 ayahs is far too many rows to insert one-at-a-time
  /// with an awaited statement each (thousands of round trips) — this
  /// stayed well within the odd hundred-millisecond range for every other
  /// bundled content type, but at Quran scale it was slow enough to blow
  /// past test pump budgets, and would make a real device's first launch
  /// noticeably slow too. So: batch-insert everything in one shot on the
  /// (overwhelmingly common) first-import case, where there's no possible
  /// unique-key collision to resolve. A version-bump re-import (rare —
  /// only when this method's bundled content next changes) falls back to
  /// the slower per-row upsert, which correctly preserves each ayah's
  /// existing `id` — and therefore any [QuranBookmarks]/[AyahNotes]
  /// pointing at it — instead of dropping and recreating rows.
  Future<void> _importQuran() async {
    final alreadyImported = await (_db.selectOnly(_db.surahs)
          ..addColumns([_db.surahs.id])
          ..limit(1))
        .getSingleOrNull();

    if (alreadyImported == null) {
      await _importQuranFast();
    } else {
      await _importQuranWithUpsert();
    }
  }

  Future<void> _importQuranFast() async {
    final allSurahData = await _loadAllSurahData();

    await _db.batch((batch) {
      batch.insertAll(_db.surahs, [
        for (final surahData in allSurahData)
          SurahsCompanion.insert(
            number: surahData['number'] as int,
            nameArabic: surahData['name_arabic'] as String,
            nameEnglish: surahData['name_english'] as String,
            nameTransliteration: surahData['name_transliteration'] as String,
            revelationType: surahData['revelation_type'] as String,
            ayahCount: (surahData['ayahs'] as List).length,
          ),
      ]);
    });

    final surahs = await _db.select(_db.surahs).get();
    final surahIdByNumber = {for (final s in surahs) s.number: s.id};

    await _db.batch((batch) {
      for (final surahData in allSurahData) {
        final surahId = surahIdByNumber[surahData['number'] as int]!;
        final ayahsData = (surahData['ayahs'] as List).cast<Map<String, dynamic>>();

        batch.insertAll(_db.ayahs, [
          for (final ayahData in ayahsData) _ayahCompanion(surahId, ayahData),
        ]);
      }
    });
  }

  Future<void> _importQuranWithUpsert() async {
    for (final surahData in await _loadAllSurahData()) {
      final ayahsData = (surahData['ayahs'] as List).cast<Map<String, dynamic>>();

      final surahCompanion = SurahsCompanion.insert(
        number: surahData['number'] as int,
        nameArabic: surahData['name_arabic'] as String,
        nameEnglish: surahData['name_english'] as String,
        nameTransliteration: surahData['name_transliteration'] as String,
        revelationType: surahData['revelation_type'] as String,
        ayahCount: ayahsData.length,
      );

      await _db
          .into(_db.surahs)
          .insert(surahCompanion, onConflict: DoUpdate((_) => surahCompanion, target: [_db.surahs.number]));

      final surah = await (_db.select(
        _db.surahs,
      )..where((t) => t.number.equals(surahData['number'] as int))).getSingle();

      for (final ayahData in ayahsData) {
        final ayahCompanion = _ayahCompanion(surah.id, ayahData);

        await _db
            .into(_db.ayahs)
            .insert(
              ayahCompanion,
              onConflict: DoUpdate((_) => ayahCompanion, target: [_db.ayahs.surahId, _db.ayahs.numberInSurah]),
            );
      }
    }
  }

  AyahsCompanion _ayahCompanion(int surahId, Map<String, dynamic> ayahData) {
    final translations = (ayahData['translations'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final translationText = translations.isNotEmpty ? translations.first['text'] as String : '';

    return AyahsCompanion.insert(
      surahId: surahId,
      numberInSurah: ayahData['number_in_surah'] as int,
      juz: Value(ayahData['juz'] as int?),
      page: Value(ayahData['page'] as int?),
      arabicText: ayahData['arabic_text'] as String,
      translation: translationText,
    );
  }
}
