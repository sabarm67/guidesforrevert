import 'package:flutter_test/flutter_test.dart';
import 'package:new_muslim_companion/features/quran/quran_ayah_text.dart';

// All Arabic fixtures below are built from exact codepoints copied out of
// this app's real bundled seed data (content/seed/quran/*.json), not
// hand-typed — see docs/architecture/arabic-quran-text-rendering-lessons.md
// for why a hand-typed comparison string is a trap for this exact text.
// hideBrokenAnnotationMarks now lives in theme/arabic_text_fixes.dart —
// see test/theme/arabic_text_fixes_test.dart for its tests.

String _fromCodes(List<int> codes) => String.fromCharCodes(codes);

final canonicalBismillah = _fromCodes([
  0x0628, 0x0650, 0x0633, 0x0652, 0x0645, 0x0650, 0x0020, 0x0671, 0x0644, 0x0644, 0x0651, 0x064e,
  0x0647, 0x0650, 0x0020, 0x0671, 0x0644, 0x0631, 0x0651, 0x064e, 0x062d, 0x0652, 0x0645, 0x064e,
  0x0670, 0x0646, 0x0650, 0x0020, 0x0671, 0x0644, 0x0631, 0x0651, 0x064e, 0x062d, 0x0650, 0x064a,
  0x0645, 0x0650,
]);

// Al-Baqarah ayah 1: canonical Bismillah + "الٓمٓ" run together, exactly as
// stored (real bug this app must correct at render time).
final alBaqarahAyah1 = _fromCodes([
  0x0628, 0x0650, 0x0633, 0x0652, 0x0645, 0x0650, 0x0020, 0x0671, 0x0644, 0x0644, 0x0651, 0x064e,
  0x0647, 0x0650, 0x0020, 0x0671, 0x0644, 0x0631, 0x0651, 0x064e, 0x062d, 0x0652, 0x0645, 0x064e,
  0x0670, 0x0646, 0x0650, 0x0020, 0x0671, 0x0644, 0x0631, 0x0651, 0x064e, 0x062d, 0x0650, 0x064a,
  0x0645, 0x0650, 0x0020, 0x0627, 0x0644, 0x0653, 0x0645, 0x0653,
]);

final alBaqarahAyah1Rest = _fromCodes([0x0627, 0x0644, 0x0653, 0x0645, 0x0653]);

// At-Tawbah ayah 1: no Bismillah at all — the one surah that genuinely
// opens without it.
final atTawbahAyah1 = _fromCodes([
  0x0628, 0x064e, 0x0631, 0x064e, 0x0627, 0x0653, 0x0621, 0x064e, 0x0629, 0x064c, 0x06ed, 0x0020,
  0x0645, 0x0651, 0x0650, 0x0646, 0x064e, 0x0020, 0x0671, 0x0644, 0x0644, 0x0651, 0x064e, 0x0647,
  0x0650, 0x0020, 0x0648, 0x064e, 0x0631, 0x064e, 0x0633, 0x064f, 0x0648, 0x0644, 0x0650, 0x0647,
  0x0650, 0x06e6, 0x0653,
]);

// At-Tin ayah 1: a real data quirk — its Bismillah carries an extra shadda
// (0x0651) on the first letter that Al-Fatihah's own copy doesn't have, so
// a byte-exact comparison against [canonicalBismillah] would miss it even
// though the words are the same. This is why splitLeadingBismillah compares
// base letters only.
final atTinAyah1 = _fromCodes([
  0x0628, 0x0651, 0x0650, 0x0633, 0x0652, 0x0645, 0x0650, 0x0020, 0x0671, 0x0644, 0x0644, 0x0651,
  0x064e, 0x0647, 0x0650, 0x0020, 0x0671, 0x0644, 0x0631, 0x0651, 0x064e, 0x062d, 0x0652, 0x0645,
  0x064e, 0x0670, 0x0646, 0x0650, 0x0020, 0x0671, 0x0644, 0x0631, 0x0651, 0x064e, 0x062d, 0x0650,
  0x064a, 0x0645, 0x0650, 0x0020, 0x0648, 0x064e, 0x0671, 0x0644, 0x062a, 0x0651, 0x0650, 0x064a,
  0x0646, 0x0650,
]);

void main() {
  group('splitLeadingBismillah', () {
    test('splits the Bismillah off a surah other than Al-Fatihah', () {
      final split = splitLeadingBismillah(alBaqarahAyah1, canonicalBismillah: canonicalBismillah);

      expect(split, isNotNull);
      expect(split!.rest, alBaqarahAyah1Rest);
      expect(split.bismillah, canonicalBismillah);
    });

    test('returns null for At-Tawbah, which has no Bismillah', () {
      final split = splitLeadingBismillah(atTawbahAyah1, canonicalBismillah: canonicalBismillah);

      expect(split, isNull);
    });

    test('returns null for Al-Fatihah itself (nothing follows the Bismillah)', () {
      final split = splitLeadingBismillah(canonicalBismillah, canonicalBismillah: canonicalBismillah);

      expect(split, isNull);
    });

    test('still splits when the stored Bismillah has extra diacritics the canonical form lacks', () {
      final split = splitLeadingBismillah(atTinAyah1, canonicalBismillah: canonicalBismillah);

      expect(split, isNotNull);
      expect(split!.rest, isNotEmpty);
      expect(split.bismillah, isNot(canonicalBismillah));
    });
  });

  group('normalizeArabicForSearch', () {
    test('matches a plain-keyboard-typed query against Quran-orthography stored text', () {
      // "بِسْمِ" as it's actually stored (starts with a plain beh, no
      // letter-shape issue there) followed by "ٱللَّهِ" using alef WASLA
      // (0x0671) — the Quran-specific letter shape a normal keyboard would
      // never produce; a user would type plain alef (0x0627) instead.
      final storedAllah = _fromCodes([0x0671, 0x0644, 0x0644, 0x0651, 0x064e, 0x0647, 0x0650]);
      final typedAllah = _fromCodes([0x0627, 0x0644, 0x0644, 0x0647]); // "الله", plain alef, no diacritics

      expect(normalizeArabicForSearch(storedAllah), normalizeArabicForSearch(typedAllah));
    });

    test('is a substring match after normalization, for use in .contains()', () {
      final normalizedQuery = normalizeArabicForSearch(_fromCodes([0x0627, 0x0644, 0x0644, 0x0647]));
      final normalizedAyah = normalizeArabicForSearch(canonicalBismillah);

      expect(normalizedAyah.contains(normalizedQuery), isTrue);
    });
  });
}
