/// Pure Dart, on-device FAQ matching — no ML model, no network call. See
/// docs/ai-mentor/ai-mentor-design.md for the full rationale: this is a
/// deliberate ceiling on capability (retrieval-only over a curated,
/// scholar-reviewed dataset) in exchange for the guarantee that the Mentor
/// can never fabricate an answer or issue a novel ruling.
library;

/// A single entry to match against — a plain data class with no Flutter or
/// Drift dependency, so this file has zero widget dependency and is
/// directly unit-testable.
class FaqMatchEntry {
  const FaqMatchEntry({
    required this.key,
    required this.canonicalQuestion,
    required this.questionVariants,
    required this.keywords,
  });

  final String key;
  final String canonicalQuestion;
  final List<String> questionVariants;
  final List<String> keywords;
}

class FaqMatchResult {
  const FaqMatchResult({required this.entry, required this.score});

  final FaqMatchEntry entry;
  final double score;
}

class AiMentorMatcher {
  AiMentorMatcher({this.primaryThreshold = 1.2, this.relatedThreshold = 0.4});

  /// Minimum score for a result to be treated as a confident primary match.
  final double primaryThreshold;

  /// Minimum score for a result to be offered as a "related question" when
  /// nothing clears [primaryThreshold].
  final double relatedThreshold;

  static const _stopwords = {
    'a',
    'an',
    'the',
    'is',
    'are',
    'do',
    'does',
    'i',
    'my',
    'me',
    'to',
    'of',
    'in',
    'on',
    'for',
    'and',
    'or',
    'it',
    'this',
    'that',
    'what',
    'how',
    'can',
    'should',
    'be',
    'im',
    "i'm",
    'as',
    'at',
  };

  List<String> normalizeAndTokenize(String input) {
    final normalized = input
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9\s']"), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (normalized.isEmpty) return const [];

    return normalized.split(' ').where((token) => token.isNotEmpty && !_stopwords.contains(token)).toList();
  }

  /// Scores every [entries] against [query] and returns results sorted by
  /// score descending. Weighted so `keywords` matches count most,
  /// `question_variants` next, and `canonical_question` least — keywords
  /// are the most deliberately curated signal in each entry. Divided by an
  /// inverse-document-frequency-style rarity weight so common words don't
  /// dominate over specific ones.
  List<FaqMatchResult> score(String query, List<FaqMatchEntry> entries) {
    final queryTokens = normalizeAndTokenize(query).toSet();

    if (queryTokens.isEmpty || entries.isEmpty) return const [];

    final documentFrequency = <String, int>{};
    final entryTokenSets = <String, _EntryTokens>{};

    for (final entry in entries) {
      final tokens = _EntryTokens(
        keywords: entry.keywords.expand(normalizeAndTokenize).toSet(),
        variants: entry.questionVariants.expand(normalizeAndTokenize).toSet(),
        canonical: normalizeAndTokenize(entry.canonicalQuestion).toSet(),
      );
      entryTokenSets[entry.key] = tokens;

      for (final token in {...tokens.keywords, ...tokens.variants, ...tokens.canonical}) {
        documentFrequency[token] = (documentFrequency[token] ?? 0) + 1;
      }
    }

    final totalEntries = entries.length;

    double rarityWeight(String token) {
      final df = documentFrequency[token] ?? 1;
      // +1 smoothing keeps this finite and > 0 even when df == totalEntries.
      return 1.0 + (totalEntries / df);
    }

    final results = <FaqMatchResult>[];

    for (final entry in entries) {
      final tokens = entryTokenSets[entry.key]!;
      var s = 0.0;

      for (final token in queryTokens) {
        final weight = rarityWeight(token);
        if (tokens.keywords.contains(token)) s += 3.0 * weight;
        if (tokens.variants.contains(token)) s += 2.0 * weight;
        if (tokens.canonical.contains(token)) s += 1.0 * weight;
      }

      // Normalize by query length so longer questions don't automatically
      // outscore short, precise ones.
      s = s / queryTokens.length;

      if (s > 0) {
        results.add(FaqMatchResult(entry: entry, score: s));
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));

    return results;
  }

  /// Returns the confident primary match (if any clears [primaryThreshold]),
  /// plus up to [maxRelated] related entries that clear [relatedThreshold].
  MatchOutcome match(String query, List<FaqMatchEntry> entries, {int maxRelated = 2}) {
    final results = score(query, entries);

    if (results.isEmpty) {
      return const MatchOutcome(primary: null, related: []);
    }

    final top = results.first;

    if (top.score >= primaryThreshold) {
      final related = results
          .skip(1)
          .where((r) => r.score >= relatedThreshold)
          .take(maxRelated)
          .map((r) => r.entry)
          .toList();

      return MatchOutcome(primary: top.entry, related: related);
    }

    final fallbackRelated = results
        .where((r) => r.score >= relatedThreshold)
        .take(maxRelated)
        .map((r) => r.entry)
        .toList();

    return MatchOutcome(primary: null, related: fallbackRelated);
  }
}

class _EntryTokens {
  _EntryTokens({required this.keywords, required this.variants, required this.canonical});

  final Set<String> keywords;
  final Set<String> variants;
  final Set<String> canonical;
}

/// The result of matching a query: either a confident [primary] match, or
/// (when nothing clears the confidence threshold) a list of [related]
/// entries to offer honestly as "you might find these related" alongside a
/// fallback message — see docs/ai-mentor/ai-mentor-design.md, step 5.
class MatchOutcome {
  const MatchOutcome({required this.primary, required this.related});

  final FaqMatchEntry? primary;
  final List<FaqMatchEntry> related;

  bool get isConfidentMatch => primary != null;
}
