# AI Mentor — On-Device Design

## Why on-device, retrieval-only (no cloud LLM)

The AI Mentor must never issue a fatwa, never fabricate an answer, and always
cite reliable sources — and it must work fully offline. A cloud LLM call
would violate the offline requirement and introduces a real risk of
hallucinated or unsourced religious claims. Instead, the Mentor is a
**pure retrieval system over a small, curated, scholar-reviewed FAQ dataset**
bundled with the app. It can only ever do one of two things:

1. Return a pre-written, pre-cited answer from `ai_faq_entries`, or
2. Say "I'm not confident I have a good answer — here's the closest related
   guidance, and please ask a qualified local scholar for your specific
   situation."

There is no generative composition step, so the Mentor is structurally
incapable of inventing a ruling or a citation. This is a deliberate ceiling on
capability in exchange for trustworthiness and offline operation. A future
version could explore an on-device embedding model for fuzzier phrasing
matches (noted below), but that is out of scope for this phase.

## Data shape

Each entry (`content/seed/ai-mentor-faq.json`, mirrored in the `ai_faq_entries`
table and the Drift `AiFaqEntries` table):

```json
{
  "id": "faq_family_disclosure_001",
  "canonical_question": "Do I need to tell my family I've become Muslim?",
  "question_variants": [
    "should i tell my parents im muslim",
    "how do i tell my family i converted",
    "coming out as muslim to family"
  ],
  "keywords": ["family", "parents", "tell", "reveal", "convert", "disclose"],
  "category": "family_and_social",
  "answer_text": "There's no single rule that fits everyone here. Many new Muslims choose to share gradually, when they feel safe and ready...",
  "source_citations": [
    { "type": "lesson", "id": "stage1-lesson2-the-shahada", "label": "Lesson: The Shahada" }
  ],
  "confidence": "general_guidance",
  "requires_scholar_disclaimer": false
}
```

`confidence` is either `general_guidance` (safe, well-established beginner
information) or `requires_scholar` (anything touching personal
circumstances or disputed fiqh detail) — entries marked `requires_scholar`
always render the "consult a qualified scholar" disclaimer prominently,
regardless of match confidence.

## Matching algorithm (pure Dart, no ML model, no network)

Implemented in `app/lib/features/ai_mentor/ai_mentor_matcher.dart`, with zero
Flutter/widget dependency so it is directly unit-testable.

1. **Normalize** the user's typed question: lowercase, strip punctuation,
   collapse whitespace.
2. **Tokenize** on whitespace; drop a small hardcoded English stopword list
   (`the`, `is`, `do`, `i`, `a`, ...).
3. **Score** every FAQ entry against the query tokens using a lightweight
   TF-IDF-style overlap:
   - Build the term corpus from every entry's `canonical_question` +
     `question_variants` + `keywords` (a few dozen entries in this phase, so
     computing this at runtime on-device is trivially cheap — no
     precomputation or persistence needed).
   - For each entry, compute a weighted overlap score between the query's
     tokens and the entry's tokens: matches against `keywords` are weighted
     highest, `question_variants` next, `canonical_question` last (keywords
     are the most deliberately curated signal).
   - Divide by a rarity weight (inverse document frequency across all
     entries) so common words (e.g. "prayer") don't dominate over specific
     ones (e.g. "wudu", "disclosure").
4. **Threshold.** If the top-scoring entry clears a minimum confidence
   threshold, return it as the primary match, plus the next 1-2 entries as
   "related questions" if they also clear a lower secondary threshold.
5. **Fallback.** If nothing clears the threshold, respond with: an honest
   "I'm not sure I have a good answer for that" message, the closest 1-2
   entries anyway (labelled as "you might find these related"), and the
   standing scholar-consultation note.
6. **Citations always render.** Every response — matched or fallback —
   shows an expandable "Sources" section listing `source_citations`, each
   deep-linking (via `go_router`) to the actual bundled lesson/dua/hadith
   screen. Citations never point to external URLs, since the app is offline
   by default.

## UI behaviour

`ai_mentor_screen.dart` is a simple chat-style interface:
- Text input for the user's question.
- Response bubble with the matched (or fallback) answer.
- Expandable "Sources" list under each response.
- A **persistent banner**, always visible on this screen:

  > "This is general guidance from an offline library, not a personal
  > religious ruling. For your specific situation, please consult a
  > qualified scholar."

## Explicitly future work (not built this phase)

- A true semantic-embedding upgrade (e.g. a small on-device sentence-embedding
  model via `tflite_flutter` or ONNX Runtime) to handle fuzzier phrasing that
  keyword overlap misses. Deliberately deferred to keep the Foundation
  Package's app size and complexity down — keyword/variant matching over a
  curated dataset is "good enough" for a first pass and fails safely (falls
  back honestly rather than guessing).
- Detecting user confusion/frustration across a conversation and proactively
  recommending a lesson (the "detect confusion" requirement from the product
  brief) — this phase only handles single-turn Q&A, not a stateful
  conversational session.
- Any server-side/cloud path for the Mentor. If this is ever considered, it
  must preserve the same guarantees: no fatwas, mandatory citations, and a
  clear "consult a scholar" disclaimer — the on-device design above achieves
  those guarantees structurally, and any future architecture change should be
  held to the same bar.
