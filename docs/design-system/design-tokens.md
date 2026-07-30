# Design System — New Muslim Companion

`design-tokens.json` in this folder is the canonical, machine-readable source
of truth. This document explains the reasoning; the Flutter theme
(`frontend/lib/theme/`) hardcodes these same values rather than deriving them
algorithmically, since the palette is hand-designed, not seed-generated.

## Visual direction

- **Warm, not clinical.** A soft sage green (`primary` `#2E7D5B`) paired with
  a muted gold (`secondary` `#D4A24C`) on a warm cream background
  (`#FBF8F3`) — calm and welcoming rather than stark white, and deliberately
  understated rather than leaning on the "green-and-gold mosque cliché."
- **Rounded, minimal cards.** 16dp corner radius on cards, 24dp on pill
  buttons/chips, one concept per card, generous spacing (`md`/`lg` tokens)
  so screens don't feel dense. This directly serves the "no clutter, one
  concept per page" requirement.
- **Material 3 as the base system** (`useMaterial3: true` in Flutter) — it
  ships adaptive `NavigationBar`/`NavigationRail` widgets out of the box,
  which the app needs anyway for a single codebase spanning phone and
  desktop/web layouts (see `breakpoints` token: 600dp / 840dp, Material 3's
  documented compact/medium/expanded cutoffs).
- **Two font families.** `Inter` for Latin UI/body text (clear, highly
  legible at small sizes — important for an audience that may include older
  or less tech-fluent users), and `AmiriQuran` (a proper Naskh-style Arabic
  typeface) for all Arabic text — Quran ayahs, dua Arabic, transliteration
  callouts. A Latin font's fallback glyphs are not acceptable for Quranic
  text; a dedicated Arabic typeface is required both for correctness and
  respect for the text.
- **Dark mode** is a first-class token set (`dark` in the JSON), not an
  afterthought — required by the Accessibility section of the product spec.

## Critical offline-first constraint

Font files **must** be bundled locally (`frontend/assets/fonts/*.ttf`, declared in
`pubspec.yaml`). Do **not** use the `google_fonts` package's default runtime
behaviour, which fetches font files over the network on first use — that
would silently break on a first launch with no connectivity, directly
violating the app's core offline-first requirement. Download `Inter` and
`AmiriQuran`/`Amiri` `.ttf` files once during development and ship them as
static assets.

## Token categories

| Category | Purpose |
|---|---|
| `color` / `dark` | Full Material 3 `ColorScheme` mapping, light and dark |
| `typography.scale` | Named type sizes, including two Arabic-specific sizes (`arabicBody`, `arabicAyah`) since Arabic script generally needs to render larger than Latin text at the same visual weight |
| `spacing` | 4/8/16/24/32/48 scale used for all padding/gaps |
| `radius` | Corner radii for cards, pills, bottom sheets, chips |
| `elevation` | Shadow depth for cards, modals, nav bars |
| `breakpoints` | Layout breakpoints for the adaptive nav shell (compact/medium/expanded) |

## Accessibility hooks (future work, tokens reserved for it)

The requirement list calls for adjustable reading levels, a colour-blind
friendly palette, and large-font/simple-English modes. This phase ships the
token structure and a palette chosen to have sufficient contrast ratios
(verify with a contrast checker before shipping — not yet formally audited),
but the actual accessibility settings screen and alternate content
variants are future work, not built in the Foundation Package.
