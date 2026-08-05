import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';

class QuranRepository {
  QuranRepository(this._db);

  final AppDatabase _db;

  Stream<List<Surah>> watchSurahs() {
    return (_db.select(_db.surahs)..orderBy([(t) => OrderingTerm.asc(t.number)])).watch();
  }

  Future<Surah?> surahByNumber(int number) {
    return (_db.select(_db.surahs)..where((t) => t.number.equals(number))).getSingleOrNull();
  }

  /// Al-Fatihah's ayah 1 *is* the Bismillah in full, so its stored text
  /// doubles as the reference used to detect and strip the Bismillah
  /// prefixed onto every other surah's ayah 1 — see
  /// [splitLeadingBismillah] in quran_ayah_text.dart. Fetched from the
  /// seeded data itself (never hand-typed) so this can never drift from
  /// whatever combining-mark encoding the actual bundled content uses.
  Future<String> canonicalBismillah() async {
    final query = _db.select(_db.ayahs).join([
      innerJoin(_db.surahs, _db.surahs.id.equalsExp(_db.ayahs.surahId)),
    ])..where(_db.surahs.number.equals(1) & _db.ayahs.numberInSurah.equals(1));

    final row = await query.getSingle();
    return row.readTable(_db.ayahs).arabicText;
  }

  Stream<List<Ayah>> watchAyahsForSurah(int surahId) {
    return (_db.select(_db.ayahs)
          ..where((t) => t.surahId.equals(surahId))
          ..orderBy([(t) => OrderingTerm.asc(t.numberInSurah)]))
        .watch();
  }

  Stream<bool> watchIsBookmarked(int ayahId) {
    return (_db.select(
      _db.quranBookmarks,
    )..where((t) => t.ayahId.equals(ayahId))).watchSingleOrNull().map((row) => row != null);
  }

  Future<void> toggleBookmark(int ayahId) async {
    final existing = await (_db.select(
      _db.quranBookmarks,
    )..where((t) => t.ayahId.equals(ayahId))).getSingleOrNull();

    if (existing != null) {
      await (_db.delete(_db.quranBookmarks)..where((t) => t.ayahId.equals(ayahId))).go();
    } else {
      await _db.into(_db.quranBookmarks).insert(QuranBookmarksCompanion.insert(ayahId: ayahId));
    }
  }

  /// Bookmarked ayahs joined with their surah, ordered newest-bookmarked
  /// first, for the bookmarks list screen.
  Stream<List<({Ayah ayah, Surah surah})>> watchBookmarkedAyahs() {
    final query = _db.select(_db.quranBookmarks).join([
      innerJoin(_db.ayahs, _db.ayahs.id.equalsExp(_db.quranBookmarks.ayahId)),
      innerJoin(_db.surahs, _db.surahs.id.equalsExp(_db.ayahs.surahId)),
    ])..orderBy([OrderingTerm.desc(_db.quranBookmarks.createdAt)]);

    return query.watch().map((rows) {
      return [
        for (final row in rows) (ayah: row.readTable(_db.ayahs), surah: row.readTable(_db.surahs)),
      ];
    });
  }

  Stream<AyahNote?> watchNoteForAyah(int ayahId) {
    return (_db.select(
      _db.ayahNotes,
    )..where((t) => t.ayahId.equals(ayahId))).watchSingleOrNull();
  }

  Future<void> upsertNote(int ayahId, String noteText) async {
    final existing = await (_db.select(
      _db.ayahNotes,
    )..where((t) => t.ayahId.equals(ayahId))).getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.ayahNotes)..where((t) => t.ayahId.equals(ayahId))).write(
        AyahNotesCompanion(noteText: Value(noteText), updatedAt: Value(DateTime.now())),
      );
    } else {
      await _db.into(_db.ayahNotes).insert(AyahNotesCompanion.insert(ayahId: ayahId, noteText: noteText));
    }
  }

  Future<void> deleteNote(int ayahId) {
    return (_db.delete(_db.ayahNotes)..where((t) => t.ayahId.equals(ayahId))).go();
  }
}

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository(ref.watch(appDatabaseProvider));
});
