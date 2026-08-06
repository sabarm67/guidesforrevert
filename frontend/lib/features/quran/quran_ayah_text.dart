/// Fix for Bug 1 in docs/architecture/arabic-quran-text-rendering-lessons.md
/// — the customary Bismillah recitation opening prefixed onto ayah 1's
/// stored text, inherited from the Tanzil/Hafazan source data. Bug 2 (the
/// six oversized-glyph annotation marks) lives in
/// ../../theme/arabic_text_fixes.dart instead, since it applies to any
/// Arabic text rendered in the bundled font, not just Quran ayahs.
library;

/// Codepoints stripped when comparing ayah text on a "base letters only"
/// basis — Arabic diacritics/annotation marks plus a stray leading BOM.
/// Matching on base letters (rather than exact bytes) is deliberate: two
/// surahs in the bundled Tanzil data (At-Tin and Al-Qadr) carry an extra
/// shadda on the Bismillah's first letter that Al-Fatihah's own copy
/// doesn't have, so a byte-exact comparison against Al-Fatihah misses them
/// even though the words are the same. The same stripping is reused by
/// [stripArabicDiacritics] for Quran search, since a user searching for a
/// phrase from memory is very unlikely to type the exact diacritics the
/// Uthmani text carries.
bool _isStrippedForComparison(int codeUnit) {
  return (codeUnit >= 0x064B && codeUnit <= 0x065F) ||
      codeUnit == 0x0670 ||
      (codeUnit >= 0x06D6 && codeUnit <= 0x06ED) ||
      codeUnit == 0xFEFF;
}

String _baseLetters(String text) {
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    if (!_isStrippedForComparison(rune)) buffer.writeCharCode(rune);
  }
  return buffer.toString();
}

/// Public wrapper around the same base-letters stripping used internally
/// by [splitLeadingBismillah], for normalizing Arabic text before a
/// substring search (see quran_repository.dart's `searchAyahs`).
String stripArabicDiacritics(String text) => _baseLetters(text);

/// Letter-shape variants folded to one canonical form before a search
/// match, on top of [stripArabicDiacritics]. Diacritic-stripping alone
/// isn't enough for search: the Uthmani text uses Quran-specific letter
/// forms — alef wasla (ٱ), alef maqsura (ى), etc. — that a user typing a
/// search query on a normal Arabic keyboard essentially never produces,
/// so without this a search for "الله" typed normally would fail to match
/// the stored "ٱللَّهِ" even after diacritics are stripped, since ٱ and ا
/// are different base codepoints, not a diacritic difference.
const _letterVariants = {
  0x0671: 0x0627, // alef wasla -> alef
  0x0622: 0x0627, // alef with madda above -> alef
  0x0623: 0x0627, // alef with hamza above -> alef
  0x0625: 0x0627, // alef with hamza below -> alef
  0x0649: 0x064A, // alef maqsura -> yeh
};

/// Normalizes Arabic text for search matching: strips diacritics/annotation
/// marks (see [stripArabicDiacritics]) and folds Quran-specific letter
/// shapes to the plain forms a normal keyboard produces.
String normalizeArabicForSearch(String text) {
  final buffer = StringBuffer();
  for (final rune in _baseLetters(text).runes) {
    buffer.writeCharCode(_letterVariants[rune] ?? rune);
  }
  return buffer.toString();
}

class BismillahSplit {
  const BismillahSplit({required this.bismillah, required this.rest});

  /// The Bismillah words exactly as they appear in this ayah's own text
  /// (own diacritics kept, not swapped for the canonical reference's).
  final String bismillah;

  /// The remaining ayah text after the Bismillah words are removed.
  final String rest;
}

/// Every surah except Al-Fatihah (where ayah 1 genuinely *is* the
/// Bismillah) and At-Tawbah (which has none) carries the customary
/// Bismillah recitation opening prefixed onto ayah 1's stored text. This
/// splits it off so it can be rendered as a separate heading instead of
/// running into the real ayah content as one sentence.
///
/// Returns null when [ayahText] doesn't open with the Bismillah (At-Tawbah,
/// or nothing follows it — Al-Fatihah's own ayah 1), in which case the
/// caller should render [ayahText] unchanged.
BismillahSplit? splitLeadingBismillah(String ayahText, {required String canonicalBismillah}) {
  final words = ayahText.split(' ');
  final canonicalWords = canonicalBismillah.split(' ');
  if (words.length <= canonicalWords.length) return null;

  for (var i = 0; i < canonicalWords.length; i++) {
    if (_baseLetters(words[i]) != _baseLetters(canonicalWords[i])) return null;
  }

  return BismillahSplit(
    bismillah: words.take(canonicalWords.length).join(' '),
    rest: words.skip(canonicalWords.length).join(' ').trim(),
  );
}
