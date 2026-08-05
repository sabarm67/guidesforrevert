/// Fixes for the two Uthmani-text rendering bugs documented in
/// docs/architecture/arabic-quran-text-rendering-lessons.md — both
/// inherited from the Tanzil/Hafazan source data plus the bundled
/// UthmanicHafs font, not introduced by this app's own content.
library;

/// Codepoints stripped when comparing ayah text on a "base letters only"
/// basis in [splitLeadingBismillah] — Arabic diacritics/annotation marks
/// plus a stray leading BOM. Matching on base letters (rather than exact
/// bytes) is deliberate: two surahs in the bundled Tanzil data (At-Tin and
/// Al-Qadr) carry an extra shadda on the Bismillah's first letter that
/// Al-Fatihah's own copy doesn't have, so a byte-exact comparison against
/// Al-Fatihah misses them even though the words are the same.
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

/// Six Quranic annotation marks (of the U+06D6-U+06ED block) that the
/// bundled UthmanicHafs font renders as oversized, disconnected glyphs —
/// intrusive dots/rosettes breaking up the word — instead of the small
/// superscript decorations a correctly-hinted Quran font shows. Hidden at
/// render time only; never strip these from stored ayah text, since any
/// future feature that indexes into the raw string (tajweed highlighting,
/// search) needs the full text to index against.
const _brokenAnnotationMarks = {0x06DE, 0x06DF, 0x06E5, 0x06E6, 0x06E9, 0x06ED};

String hideBrokenAnnotationMarks(String text) {
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    if (!_brokenAnnotationMarks.contains(rune)) buffer.writeCharCode(rune);
  }
  return buffer.toString();
}
