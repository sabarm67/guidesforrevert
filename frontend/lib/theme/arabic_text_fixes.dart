/// Render-time fix for Bug 2 in
/// docs/architecture/arabic-quran-text-rendering-lessons.md: six Quranic
/// annotation marks (of the U+06D6-U+06ED block) that the bundled
/// UthmanicHafs font (see [AppTypography.arabicFontFamily]) renders as
/// oversized, disconnected glyphs — intrusive dots/rosettes breaking up
/// the word — instead of the small superscript decorations a
/// correctly-hinted Quran font shows.
///
/// This isn't Quran-screen-specific: any Arabic text rendered in this font
/// can carry these marks if it was ever copied from or quotes Uthmani
/// Quran text (duas, lesson quote blocks, surah names), so every render
/// site using [AppTypography.arabic] should pass its text through this
/// first. Hide at render time only — never strip these from stored text,
/// since any future feature that indexes into the raw string (tajweed
/// highlighting, search) needs the full text to index against.
library;

const _brokenAnnotationMarks = {0x06DE, 0x06DF, 0x06E5, 0x06E6, 0x06E9, 0x06ED};

String hideBrokenAnnotationMarks(String text) {
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    if (!_brokenAnnotationMarks.contains(rune)) buffer.writeCharCode(rune);
  }
  return buffer.toString();
}
