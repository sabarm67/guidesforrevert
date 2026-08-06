import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_muslim_companion/core/db/app_database.dart';
import 'package:new_muslim_companion/core/db/seed_importer.dart';
import 'package:new_muslim_companion/features/quran/quran_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late QuranRepository repository;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await SeedImporter(db).importIfNeeded();
    repository = QuranRepository(db);
  });

  tearDown(() => db.close());

  test('finds ayahs by an English translation phrase, case-insensitively', () async {
    final results = await repository.searchAyahs('Lord of the Worlds');

    expect(results, isNotEmpty);
    expect(results.first.surah.number, 1);
    expect(results.first.ayah.numberInSurah, 2);
  });

  test('matches Arabic text even when the query has no diacritics the stored text has', () async {
    // Undiacritized "بسم الله" ("bismillah") — the stored Uthmani text is
    // fully diacritized, so this only matches if diacritics are stripped
    // from both sides before comparing.
    final results = await repository.searchAyahs('بسم الله');

    // Prefixed onto ayah 1 for every surah except Al-Fatihah (itself the
    // Bismillah) and At-Tawbah (which has none) — 112 of 114 surahs.
    expect(results.length, greaterThanOrEqualTo(100));
  });

  test('returns results sorted by surah then ayah number', () async {
    final results = await repository.searchAyahs('mercy');

    for (var i = 1; i < results.length; i++) {
      final prev = results[i - 1];
      final curr = results[i];
      final inOrder =
          prev.surah.number < curr.surah.number ||
          (prev.surah.number == curr.surah.number && prev.ayah.numberInSurah <= curr.ayah.numberInSurah);
      expect(inOrder, isTrue, reason: 'Out of order at index $i');
    }
  });

  test('returns nothing for a nonsense query', () async {
    final results = await repository.searchAyahs('zzznonexistentphrase123');

    expect(results, isEmpty);
  });

  test('returns nothing for an empty or blank query', () async {
    expect(await repository.searchAyahs(''), isEmpty);
    expect(await repository.searchAyahs('   '), isEmpty);
  });
}
