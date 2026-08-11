import 'package:flutter_test/flutter_test.dart';
import 'package:new_muslim_companion/theme/arabic_text_fixes.dart';

// At-Tawbah ayah 1, exact codepoints copied from content/seed/quran — see
// docs/architecture/arabic-quran-text-rendering-lessons.md.
final atTawbahAyah1 = String.fromCharCodes([
  0x0628, 0x064e, 0x0631, 0x064e, 0x0627, 0x0653, 0x0621, 0x064e, 0x0629, 0x064c, 0x06ed, 0x0020,
  0x0645, 0x0651, 0x0650, 0x0646, 0x064e, 0x0020, 0x0671, 0x0644, 0x0644, 0x0651, 0x064e, 0x0647,
  0x0650, 0x0020, 0x0648, 0x064e, 0x0631, 0x064e, 0x0633, 0x064f, 0x0648, 0x0644, 0x0650, 0x0647,
  0x0650, 0x06e6, 0x0653,
]);

void main() {
  group('hideBrokenAnnotationMarks', () {
    test('removes all six marks that render as oversized glyphs in UthmanicHafs', () {
      const broken = [0x06DE, 0x06DF, 0x06E5, 0x06E6, 0x06E9, 0x06ED];
      final input = String.fromCharCodes([0x0628, ...broken, 0x0645]);

      expect(hideBrokenAnnotationMarks(input), String.fromCharCodes([0x0628, 0x0645]));
    });

    test('leaves other Quranic annotation marks untouched', () {
      const workingMark = 0x06D6;
      final input = String.fromCharCodes([0x0628, workingMark, 0x0645]);

      expect(hideBrokenAnnotationMarks(input), input);
    });

    test('strips the broken marks actually present in At-Tawbah ayah 1 without touching base letters', () {
      final cleaned = hideBrokenAnnotationMarks(atTawbahAyah1);

      expect(cleaned.runes, isNot(contains(0x06ed)));
      expect(cleaned.runes, isNot(contains(0x06e6)));
      expect(cleaned.length, lessThan(atTawbahAyah1.length));
    });

    test('is a no-op on plain text with no annotation marks (e.g. a dua or surah name)', () {
      final plain = String.fromCharCodes([0x0628, 0x0650, 0x0633, 0x0652, 0x0645, 0x0650]);

      expect(hideBrokenAnnotationMarks(plain), plain);
    });

    test('replaces the Arabic comma (U+060C) with a plain comma', () {
      // "بِسْمِ اللَّهِ، تَوَكَّلْتُ" — the leaving-home dua, exact codepoints
      // copied from content/seed/duas.json, where a bare U+060C between the
      // two clauses renders as the same oversized-dot bug as the six marks
      // above, despite not being one of them.
      final input = String.fromCharCodes([
        0x0628, 0x0650, 0x0633, 0x0652, 0x0645, 0x0650, 0x0020, 0x0627, 0x0644, 0x0644, 0x064e,
        0x0651, 0x0647, 0x0650, 0x060c, 0x0020, 0x062a, 0x064e, 0x0648, 0x064e, 0x0643, 0x064e,
        0x0651, 0x0644, 0x0652, 0x062a, 0x064f,
      ]);

      final cleaned = hideBrokenAnnotationMarks(input);

      expect(cleaned.runes, isNot(contains(0x060c)));
      expect(cleaned, contains(','));
    });
  });
}
