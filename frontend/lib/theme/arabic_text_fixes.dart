/// Render-time fixes for glyphs the bundled UthmanicHafs font (see
/// [AppTypography.arabicFontFamily]) renders as oversized, disconnected
/// shapes — intrusive dots/rosettes breaking up the text — instead of
/// their correct small/inline form. UthmanicHafs is a Quran-specific font
/// (see docs/architecture/arabic-quran-text-rendering-lessons.md for Bug
/// 2, the original six-mark case), so it's never been hinted for glyphs
/// that only show up outside Quranic text, which is exactly where this
/// second case comes from:
///
/// - Six Quranic annotation marks, U+06D6-U+06ED (Bug 2 in the doc above).
/// - U+060C, the Arabic comma — not part of Quranic Uthmani text at all
///   (Tanzil/Hafazan ayahs use waqf pause marks instead, never a plain
///   comma — confirmed by scanning every bundled ayah), but it does show
///   up in this app's own dua and lesson-quote text, e.g. "Bismillah,
///   tawakkaltu 'alallah, ..." rendered with the same oversized-dot bug.
///   Replaced with a plain Latin comma rather than dropped outright,
///   since it's meaningful punctuation here rather than decoration.
///
/// This isn't Quran-screen-specific: any Arabic text rendered in this font
/// can carry these, so every render site using [AppTypography.arabic]
/// should pass its text through this first. Fixed at render time only —
/// never alter stored text, since any future feature that indexes into
/// the raw string (tajweed highlighting, search) needs the original.
library;

const _brokenAnnotationMarks = {0x06DE, 0x06DF, 0x06E5, 0x06E6, 0x06E9, 0x06ED};
const _arabicComma = 0x060C;

String hideBrokenAnnotationMarks(String text) {
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    if (_brokenAnnotationMarks.contains(rune)) continue;
    if (rune == _arabicComma) {
      buffer.write(',');
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}
