# Arabic Quran Text Rendering — Lessons from Al-Quran Hafazan System

> **Status: Bugs 1 and 2 confirmed present and fixed.** This app pulls its
> Arabic ayah text directly from Al-Quran Hafazan System's API
> (`hafazan.rcaquacycle.com/api/v1/surahs/{n}/ayat` — see
> `content/seed/SOURCES.md` and `ImportQuranContent.php`) and renders it
> with the **same font** (`UthmanicHafs` / KFGQPC "Uthmanic Script Hafs"
> — see `frontend/lib/theme/app_typography.dart`). Hafazan hit three real,
> user-reported bugs rendering this exact text with this exact font, and
> both Quran-text bugs (1 and 2) were confirmed present in this app's own
> bundled seed data and fixed:
> `frontend/lib/features/quran/quran_ayah_text.dart` holds the fix
> (`splitLeadingBismillah` + `hideBrokenAnnotationMarks`), applied in
> `frontend/lib/features/quran/surah_detail_screen.dart` before ayah text
> is ever rendered. Verified against Al-Baqarah (Bug 1's main case),
> At-Tawbah (the no-Bismillah exception), and At-Tin (a real data quirk
> found while fixing this — see "A wrinkle beyond this doc" under Bug 1),
> plus unit tests in `frontend/test/features/quran/quran_ayah_text_test.dart`
> built from exact codepoints copied out of the real seed JSON, not
> hand-typed. Bug 3 (the PWA update-mechanism gotcha) remains only a
> lesson to keep in mind if a manual update-prompt UI is ever built here —
> nothing to fix today since no such UI exists yet.

## Bug 1: Bismillah is embedded in ayah 1's text, not a separate ayah

Tanzil's Uthmani text (and therefore Hafazan's `text_arabic_uthmani`, and
therefore `ayah.arabicText` here) has `بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ
ٱلرَّحِيمِ` **prefixed onto ayah 1's string** for every surah except
At-Tawbah (which has no Bismillah at all) — *except* Al-Fatihah, where
ayah 1 genuinely **is** the Bismillah, nothing to strip.

Concretely: Al-Baqarah's `ayah.arabicText` for `numberInSurah == 1` is not
"الٓمٓ" (Alif, Laam, Miim — the actual ayah), it's `"بِسْمِ ٱللَّهِ
ٱلرَّحْمَٰنِ ٱلرَّحِيمِ الٓمٓ"` — Bismillah and the real ayah run
together as one string. Rendered as-is, every surah's opening looks like
its first ayah is a long run-on sentence starting with the Bismillah,
which is wrong — the Bismillah is a customary recitation opening, not
part of ayah 1's actual content (except in Al-Fatihah).

### The fix, and the trap inside it

The fix is: detect whether ayah 1's text starts with the Bismillah, and
if there's content after it, split it into a separate heading + the real
ayah text.

**The trap**: comparing against a hand-typed Bismillah string literal in
your own source code will silently fail for every surah except
Al-Fatihah. Not because the text differs — because of *which order the
combining diacritics come in*. Tanzil's data orders the fatha+shadda
combination in "لَّ"/"رَّ" as **shadda-then-fatha**; a Bismillah string
typed/pasted into an editor very plausibly ends up **fatha-then-shadda**
instead. Both render the *exact same glyph* — completely invisible on
inspection, in a code review, or in a debugger printing the string — but
as raw Unicode codepoint sequences they are not equal, so a plain
`startsWith`/`==` comparison returns false for everything except
Al-Fatihah (whose ayah 1 happens to round-trip through the identical
representation, since there's nothing else to compare it against).

This is exactly what happened in Hafazan: the fix appeared to work in
local testing, shipped, and then silently did nothing at all in
production for every surah except Al-Fatihah — because the *test* also
used a literal string comparison, and the discrepancy is undetectable by
eye. It was only caught because a user reported Al-Baqarah still showing
the Bismillah and "Alif Laam Miim" run together, and root-causing it
required decompiling the actual built bundle and diffing codepoints
character-by-character against a live API response — visual inspection
of the source code found nothing wrong.

**The robust fix**: normalize both strings to Unicode NFC before
comparing. Unicode's canonical ordering algorithm reorders combining
marks by combining class (fatha is class 30, shadda is class 33) —
NFC-normalizing *either* input order produces the same canonical
sequence, so the comparison becomes order-independent. This does not
affect length-based slicing/substring logic afterward: reordering two
adjacent combining marks is a pure permutation, it doesn't change
character count.

```dart
// Illustrative — not tested against Flutter/Dart's actual Unicode
// normalization APIs (Dart's core String has no built-in .normalize();
// this needs a package, e.g. `unorm_dart` or `characters` +
// ICU4X/`intl` — verify NFC support before relying on this).
//
// Pseudocode for the algorithm itself (language-agnostic):
//   1. Strip a leading BOM (U+FEFF) if present — Al-Fatihah's ayah 1 in
//      Hafazan's data has one; most other ayat don't.
//   2. NFC-normalize BOTH the Bismillah constant and the input text,
//      compare with that normalized form ONLY for the startsWith check.
//   3. Still use the ORIGINAL (non-normalized) string for the actual
//      length/slice — normalization doesn't change character count here,
//      so indices computed against the un-normalized text stay correct.
//   4. After the Bismillah's length, skip trailing whitespace to find
//      where the real ayah content starts.
//   5. If nothing follows the Bismillah, it's Al-Fatihah — don't split.
```

Whatever language/library you implement this in, **write a test that
asserts the split actually happens for a surah other than Al-Fatihah**
(Al-Baqarah is a good one) — a test using the same hand-typed constant as
the implementation will pass even when the implementation is broken,
since it's the same trap either way. Assert against the *shape* of the
result (heading text + separate first-ayah text), not just "no
exception."

### A wrinkle beyond this doc, found while fixing it here: two surahs' Bismillah isn't byte-identical to Al-Fatihah's either

Even NFC-normalizing both sides isn't quite enough on the exact bundled
data in this app. At-Tin (95) and Al-Qadr (97) both carry an **extra
shadda** (U+0651) on the Bismillah's first letter — "بِّسْمِ" instead of
"بِسْمِ" — that Al-Fatihah's own copy doesn't have. This isn't a
reordering (which NFC would fix); it's a genuinely extra codepoint, so a
byte-exact or NFC-normalized comparison against Al-Fatihah's ayah 1
silently fails to detect the Bismillah in exactly these two surahs,
leaving them with the same run-on bug Bug 1 describes.

**The fix that survives this too**: compare *base letters only* — strip
Arabic diacritics/annotation marks (U+064B–U+065F, U+0670, U+06D6–U+06ED)
from both sides before comparing, matched word-by-word (split on spaces)
rather than as one long string. This is robust to reordering (the
original trap), extra/missing diacritics (this one), and — because the
split point is found via the *original* text's word boundaries rather
than a fixed character count copied from the canonical reference — it
still slices at the right offset even when the two texts have different
lengths. Verified empirically against all 114 bundled surahs: 112/112
non-exempt surahs match on base letters (see
`frontend/lib/features/quran/quran_ayah_text.dart`,
`splitLeadingBismillah`).

## Bug 2: Six specific Quranic annotation marks render as oversized black dots with this exact font (KFGQPC Uthmanic Script Hafs)

This is the more important finding for you, since **you use the same
font**. A family of Unicode combining marks (Quranic annotation signs,
block U+06D6–U+06ED — waqf/pause marks, silent-letter markers,
nasalization indicators) are present throughout the Uthmani text. A
well-designed font renders these as small superscript marks sitting
above the previous letter, at effectively zero advance width (they don't
take up their own space in the line, they decorate the letter before
them). **KFGQPC Uthmanic Script Hafs does not render six of these
correctly** — it renders them as full-size, disconnected glyphs sitting
inline, which show up visually as an intrusive oversized dot (or a small
circle/rosette shape) breaking up the word.

This was found and fixed twice in Hafazan because the first fix only
covered the one mark a user happened to report first (U+06ED, inside
"هُدًۭى" in Al-Baqarah 2). A second report (At-Tawbah, a different word
shape — "فَسِيحُوا۟") turned out to be a *different* mark (U+06DF), which
prompted actually measuring every candidate instead of continuing to fix
them one at a time as users found each one.

**The precise, verified list** (measured via canvas `measureText` in a
browser against this exact font — a properly-designed combining mark
measures 0 width, a broken one measures 0.4–1.0× a base letter's width):

| Codepoint | Name | Renders as | Occurs in Tanzil/Hafazan text? |
|---|---|---|---|
| U+06DE | Start of Rub el Hizb | oversized rosette | Yes — 199× |
| U+06DF | Small High Rounded Zero | oversized filled dot | Yes — 3,988× (very common) |
| U+06E5 | Small Waw | oversized shape | Yes — 1,257× |
| U+06E6 | Small Yeh | oversized shape | Yes — 995× |
| U+06E9 | Place of Sajdah | oversized star | Yes — 15× |
| U+06ED | Small Low Meem | oversized filled dot | Yes — 4,807× (very common) |
| U+06DD | End of Ayah | oversized ring | **No — never occurs** (ayah boundaries are tracked as separate data, not an inline character; harmless to skip) |

Everything else in that Unicode range (U+06D6–U+06DC, U+06E0–U+06E2)
renders correctly with this font — don't hide those, they're the actual
small waqf marks doing their job. Only the six above are broken.

**How this was verified** — worth doing yourself rather than trusting
this table blindly, since a Flutter/Skia text renderer could plausibly
behave differently than a browser's:

```dart
// Illustrative — the actual measurement approach used was a browser's
// canvas 2D context `measureText()`; Flutter's equivalent is
// `TextPainter` — lay out a base letter (e.g. 'ب') alone, then each
// candidate mark alone with the same font/fontSize, and compare
// `painter.width` (or the resulting `Size`) between them. A broken mark's
// width will be a large fraction of the base letter's width; a working
// one will be ~0.
```

**The fix, same shape as Bug 1's lesson**: don't delete these characters
from stored data (if you ever add tajweed rule highlighting or anything
else that indexes into the raw string, you want the full text available
to index against) — hide them only at render time, after any such
indexing has already happened. In Hafazan this bit twice: the first
implementation hid the character *before* computing colored-highlight
segments, which shifted every subsequent color boundary by one character
for any rule after a hidden mark. The fix was reordering: build
highlight segments against the full original text and its correct
indices first, then strip the hidden marks from each segment's *display*
text as the very last step, after indices are no longer needed.

## Bug 3 (only relevant if/when you build a web/PWA target): a `registerType` gotcha that silently kills your "update available" UI

Not about Arabic text, but same root cause as the above: something that
looked correct in code review and testing, and silently didn't work in
production, and the *lesson learned about verification method* generalizes
directly.

If you ever build a manual "an update is ready, tap to refresh"
mechanism using `vite-plugin-pwa` (or any Workbox-based setup with an
equivalent concept) for a web target: the `registerType: 'autoUpdate'`
config option and a manual "waiting worker, prompt user, then refresh"
UI are **mutually exclusive**, not complementary. Under `autoUpdate`, the
library auto-activates new versions and reloads the page on its own with
no hook exposed to your app code at all — `onNeedRefresh` (the callback
a manual refresh button would depend on) is simply never called in that
mode. This is invisible in code review (both configs compile fine,
nothing errors) and easy to miss in casual testing (a plain `npm run
dev` / hot-reload session doesn't exercise the real service-worker
update lifecycle at all). It only showed up when actually simulating two
different production builds, registering the first, deploying the
second, and checking whether the browser's service worker actually
entered a `waiting` state — which requires `registerType: 'prompt'`, not
`'autoUpdate'`.

**The generalizable lesson**: for any bug involving a build step,
minification, or a service worker, testing against `npm run dev` /
Flutter's hot-reload is not sufficient evidence that a fix works — verify
against the actual production build artifact, with any relevant browser
cache/service-worker state explicitly cleared first. Both the Bismillah
bug and this one *looked* fixed in dev-mode/casual testing and weren't.

## Summary of concrete next steps for this project

1. ~~**Verify Bug 1 and Bug 2 are actually present**~~ — done. Both
   confirmed against the real bundled seed data (`content/seed/quran/*.json`):
   Al-Baqarah's ayah 1 genuinely is `"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ
   الٓمٓ"` run together, and the exact mark counts in the table above
   (e.g. U+06ED × 4,807) matched a direct count across all 114 files.
2. ~~If present, implement the Bismillah-split and hidden-mark-stripping
   logic in Dart~~ — done, in
   [`quran_ayah_text.dart`](../../frontend/lib/features/quran/quran_ayah_text.dart)
   (`splitLeadingBismillah`, `hideBrokenAnnotationMarks`), wired into
   [`surah_detail_screen.dart`](../../frontend/lib/features/quran/surah_detail_screen.dart).
   The canonical Bismillah reference is fetched from Al-Fatihah's own
   seeded ayah 1 at runtime (`QuranRepository.canonicalBismillah()`)
   rather than hand-typed, sidestepping the literal-comparison trap
   entirely rather than just guarding against it. Covered by
   [`quran_ayah_text_test.dart`](../../frontend/test/features/quran/quran_ayah_text_test.dart),
   built from exact codepoints copied out of the real seed JSON.
3. If you ever add tajweed color-highlighting to this app too (Hafazan's
   Mushaf reader has this now, sourced from the CC-BY-licensed
   `cpfair/quran-tajweed` project, remapped onto Hafazan's exact bundled
   text — see Hafazan's `scripts/tajweed-build/remap.py` if useful as a
   reference for the remapping methodology, which had its own Unicode
   pitfalls worth reading before repeating them), apply the same
   "hide-after-indexing, not before" ordering from Bug 2.
