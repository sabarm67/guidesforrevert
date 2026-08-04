# Content Sources & Licensing Notes

This seed content is a small, representative sample for the Foundation
Package — not the full content library. It exists to prove the schema and
the app's end-to-end flow work correctly. **Before this content is used in
any public or production release, every Arabic text, translation, and hadith
wording below must be independently verified against the primary sources
listed here** (e.g. Tanzil.net and sunnah.com), ideally by someone with
Arabic reading ability and/or a qualified reviewer — this seed data was
authored with care but has not had that independent verification pass yet.

## Quran text and translation

**Status: verified and safely sourced** (as of 2026-08, covering Al-Fatihah
and the full Juz 'Amma — surahs 1 and 78-114, 38 surahs / 571 ayahs).

- **Arabic text**: `text_uthmani` pulled directly from the official
  `api.quran.com` API, which mirrors the Tanzil Project's Uthmani Quran
  text. Tanzil's terms (confirmed at tanzil.net/download) grant permission
  to copy and distribute verbatim copies of the text in any application,
  commercial or not, provided the source (Tanzil Project) is credited with
  a link to tanzil.net — done via this note. Text must not be altered.
- **Translation**: **Pickthall** (Mohammed Marmaduke William Pickthall,
  1930) — chosen specifically because it is a public-domain English
  translation (pre-1964 US publication, copyright not renewed), unlike
  modern translations such as Saheeh International, the Clear Quran, or
  Abdul Haleem, which remain under active copyright and are NOT safe to
  redistribute without a direct license from the publisher. Tanzil's own
  translation downloads are explicitly restricted to non-commercial use
  unless the translator/publisher grants permission — Pickthall's
  public-domain status is what makes it usable regardless of that
  restriction. Text pulled via `api.quran.com/api/v4/verses/by_chapter`,
  translation resource id 19.
- **Reproducing/expanding**: `php artisan quran:import {surah_numbers*}`
  (see `app/Console/Commands/ImportQuranContent.php`) regenerates seed
  files from the live API — a content-authoring tool run locally, never
  called by the shipped app at runtime.
- **Tafsir summaries**: the summaries attributed to Ibn Kathir and Al-Sa'di
  on Al-Fatihah are **original short summaries written by this project**,
  not verbatim translations of their tafsir works — this is deliberate, to
  avoid redistributing full copyrighted/translated tafsir text without
  clear licensing. The auto-imported Juz 'Amma surahs have no tafsir yet.
- **Known remaining risk**: the Quranic verse quotes embedded *inside*
  lesson content (`content/seed/lessons/*.json`, `"type": "quote"` blocks)
  are still unverified LLM-generated text loosely attributed to "Saheeh
  International" — the same risk this section used to describe. They were
  NOT covered by the fix above and should be replaced with verified
  Pickthall (or another confirmed-safe) text the same way, ideally before
  any public release.

## Hadith

- **An-Nawawi's 40 Hadith**: English wording in
  `content/seed/hadith/nawawi40-seed.json` is adapted from commonly
  published English renderings (e.g. as available via sunnah.com); Arabic
  text should be cross-checked against sunnah.com's Arabic text before
  production use. Authenticity grading (`sahih`) reflects the standard
  classification for these particular hadiths (all agreed upon by Bukhari
  and Muslim), which is why An-Nawawi's collection is considered a safe,
  authoritative starting point for beginners.

## Duas

- Wordings and gradings (`sahih`/`hasan`) in `content/seed/duas.json` follow
  commonly cited classifications for these well-known duas (Bukhari, Muslim,
  Abu Dawud, At-Tirmidhi). Cross-check against a Hisnul Muslim ("Fortress of
  the Muslim") edition or sunnah.com before production use, as slight
  wording variants exist across compilations.

## Lessons

- All 28 lessons across Stages 1-4 in `content/seed/lessons/` are original
  educational writing produced for this project, drawing on mainstream
  Sunni consensus positions. They are not a translation of any single
  external source, but the Quranic quotations within them follow the same
  Saheeh International sourcing note above, and any hadith quotations
  (e.g. the Wudu, mosque-entry, and greeting hadiths in Stage 2; the
  dhikr, family, food, and charity hadiths in Stage 3; and the Seerah,
  companions, and community hadiths in Stage 4) follow the same
  commonly-published-English-wording caveat as the An-Nawawi's 40 note
  above — cross-check exact wording against sunnah.com before production
  use. Where a lesson describes a step-by-step practice with minor
  variation between the Sunni schools of law (e.g. Wudu's exact
  head-wiping method), or references genuinely disputed fiqh questions
  (e.g. interfaith marriage in the Stage 4 marriage lesson), the lesson
  says so explicitly and defers to a local imam rather than presenting one
  view as the only valid one. The Stage 4 "Islamic History" and "Islamic
  Civilisation" lessons summarise widely documented historical facts
  (dates, dynasties, named scholars) rather than religious rulings, so
  they carry lower sourcing risk but should still be spot-checked for
  factual accuracy before production use.
- **Understanding the Azan** (Stage 2, inserted ahead of Wudu/Salah) breaks
  the call to prayer down phrase-by-phrase via `quote` blocks with Arabic,
  transliteration, and translation for each phrase. Wording follows the
  standard, essentially universal Sunni Azan text; the Fajr-only "Prayer is
  better than sleep" addition is described in the body text rather than as
  a separate quote block. Same sourcing caveat as the rest of this section
  applies — cross-check transliteration/translation wording before
  production use.
- **The Five Pillars of Islam** and **The Six Articles of Faith** (Stage 1,
  now lessons 3-4 — moved up from 5-6 so the two frameworks are
  introduced early, with Who is Allah/Shahadah/Quran/Muhammad reframed as
  supporting deep-dives into specific pillars/articles rather than
  free-standing topics) both quote the Hadith of Gabriel (Sahih al-Bukhari / Sahih
  Muslim) — the well-known hadith in which the Angel Gabriel asks the
  Prophet to define Islam (the five pillars) and Iman (the six articles)
  in turn. Wording is a commonly-published English rendering, same caveat
  as the rest of this section — cross-check against sunnah.com before
  production use. The Six Articles lesson's treatment of Qadar (divine
  decree) versus human free will reflects mainstream Sunni theological
  consensus (both are held to be true and compatible) rather than staking
  out a position in the deeper classical Ash'ari/Maturidi/Mu'tazila
  debate on exactly how — this simplification is appropriate for a
  beginner-level lesson but is worth flagging for a scholarly review pass.
- **Prayer Guide** (3 lessons, surfaced on the Prayer tab rather than the
  Learning tab): "How to Perform Wudu" and "How to Pray Salah" are the
  full step-by-step guides moved unchanged from the former Stage 2
  Wudu/Salah lessons (same sourcing notes as those apply — see the Wudu
  hadith and Quran 2:153 citations). "Types of Prayer" is new content
  describing Fard/Sunnah/Nafl/Witr/Tarawih/Eid/Janazah/Istikhara/Qasr
  &amp; Jama — original writing summarising mainstream, uncontroversial
  fiqh categories with no direct scriptural quotations, so it carries
  comparatively low sourcing risk. "How to Pray Salah" also gained a
  Qiblah-facing section and expanded posture detail per rak'ah step (hand
  position during Qiyam, elbow position in Sujud, foot position while
  sitting, etc.) — commonly taught beginner-level detail with no new
  scriptural quotations, though exact hand-position convention is noted
  as varying slightly by madhhab, consistent with the Wudu lesson's
  existing head-wiping caveat. The Prayer tab's live Qibla bearing chip
  uses `adhan_dart`'s built-in `Qibla.qibla()` spherical-trigonometry
  calculation (already a dependency, no new package), not a citation, so
  it carries no sourcing risk beyond the underlying math being correct.
  "Types of Prayer" and the rest of the Prayer Guide should still have
  exact rak'ah counts and rulings spot-checked before production use, as
  minor details (e.g. which Sunnah prayers are Mu'akkadah) vary slightly
  by madhhab.
- **Fiqh in Daily Life** (9 lessons) and **Understanding Islam: Addressing
  Misconceptions** (31 lessons, expanded from an initial 9) are likewise
  original writing, following the same Quranic-quotation sourcing caveat
  above. The misconceptions collection in particular makes historical
  claims (e.g. Indonesia's conversion via trade rather than conquest, the
  persistence of Coptic Christians and other non-Muslim populations under
  centuries of Muslim rule, mainstream fatwa councils' positions on honor
  killing/FGM/violent extremism) that are widely documented in mainstream
  historical and Islamic scholarship, but were not independently
  fact-checked source-by-source in this writing pass — verify specific
  historical and statistical claims before public release, the same as any
  other factual content in this app. These lessons address sensitive,
  high-stakes topics (violence, women's rights, honor killing, FGM) and
  would particularly benefit from a qualified scholarly review pass before
  production use, beyond the general verification note at the top of this
  file.
  - The 22-lesson expansion (`misconceptions-lesson10` through
    `misconceptions-lesson31`) adds several topics that raise this need
    further rather than reducing it: **apostasy**
    (`misconceptions-lesson26-apostasy-leaving-islam.json`) was written to
    honestly represent genuine classical-vs-contemporary scholarly
    diversity and the real-world legal picture (Western countries vs. some
    Muslim-majority countries) rather than asserting one settled view;
    **child marriage**
    (`misconceptions-lesson27-child-marriage.json`) deliberately avoids
    asserting a specific age for Aisha given genuine historian debate, and
    frames the topic through historical context and modern legislated
    minimum-age consensus; **slavery in Islamic history**
    (`misconceptions-lesson30-slavery-in-islamic-history.json`) is
    intentionally direct that classical Islamic law regulated and
    incentivised manumission but did not categorically abolish slavery,
    distinct from the modern legal-abolition claim; **evolution**
    (`misconceptions-lesson31-science-and-evolution.json`) is honest that
    Muslim scholarly/popular opinion on evolution specifically (as opposed
    to science generally) is genuinely mixed rather than presenting one
    resolved position. None of these four lessons' claims have been
    independently fact-checked source-by-source, and given the
    reputational/pastoral sensitivity of apostasy, child marriage, and
    slavery specifically, a qualified scholarly review pass is strongly
    recommended before any public release of this expanded collection.

## General principle for content going forward

Only mainstream Sunni sources should be used (see the product brief's
"Content Sources" section): Tanzil (Arabic) + Pickthall (default, public
domain) for Quran, with Saheeh International / The Clear Quran / Abdul
Haleem usable only after obtaining an actual license or written permission
from the respective publisher/translator; Ibn Kathir, Al-Sa'di, Al-Tabari
original summaries for tafsir; Sahih al-Bukhari, Sahih Muslim, Riyad
as-Salihin, and An-Nawawi's 40 for hadith — via sunnah.com's official API
(api.sunnah.com, requires a free registered API key) once available, rather
than LLM-paraphrased "commonly published" wording. Where scholarly opinion
differs (e.g. between madhhabs on fiqh questions), that difference should be
labelled explicitly rather than presenting one view as the only one — this
is not yet needed for the small seed set here, but will matter as soon as
the content library grows into fiqh-heavy topics (e.g. detailed prayer
rulings).
