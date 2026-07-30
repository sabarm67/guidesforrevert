import 'package:flutter_test/flutter_test.dart';
import 'package:new_muslim_companion/features/ai_mentor/ai_mentor_matcher.dart';

void main() {
  final entries = [
    const FaqMatchEntry(
      key: 'faq_family_disclosure_001',
      canonicalQuestion: "Do I need to tell my family I've become Muslim?",
      questionVariants: [
        'should i tell my parents im muslim',
        'how do i tell my family i converted',
        'coming out as muslim to family',
      ],
      keywords: ['family', 'parents', 'tell', 'reveal', 'convert', 'disclose'],
    ),
    const FaqMatchEntry(
      key: 'faq_arabic_needed_002',
      canonicalQuestion: 'Do I need to know Arabic immediately?',
      questionVariants: ['do i have to learn arabic right away', 'can i be muslim without knowing arabic'],
      keywords: ['arabic', 'language', 'learn', 'immediately', 'quran'],
    ),
    const FaqMatchEntry(
      key: 'faq_prayer_mistakes_003',
      canonicalQuestion: 'Can I pray if I make mistakes?',
      questionVariants: ['what if i mess up during prayer', 'is my prayer invalid if i make a mistake'],
      keywords: ['prayer', 'salah', 'mistake', 'wrong', 'invalid'],
    ),
  ];

  group('AiMentorMatcher.normalizeAndTokenize', () {
    test('lowercases, strips punctuation, and drops stopwords', () {
      final matcher = AiMentorMatcher();

      final tokens = matcher.normalizeAndTokenize("Do I Need to know Arabic, right away?!");

      expect(tokens, containsAll(['need', 'know', 'arabic', 'right', 'away']));
      expect(tokens, isNot(contains('do')));
      expect(tokens, isNot(contains('to')));
    });

    test('returns an empty list for input that is only stopwords/punctuation', () {
      final matcher = AiMentorMatcher();

      expect(matcher.normalizeAndTokenize('Is it the?'), isEmpty);
    });
  });

  group('AiMentorMatcher.match', () {
    test('confidently matches a close phrasing of a seeded variant', () {
      final matcher = AiMentorMatcher();

      final outcome = matcher.match('should i tell my parents im muslim', entries);

      expect(outcome.isConfidentMatch, isTrue);
      expect(outcome.primary!.key, 'faq_family_disclosure_001');
    });

    test('confidently matches on keyword overlap even with different phrasing', () {
      final matcher = AiMentorMatcher();

      final outcome = matcher.match('do muslims need arabic language skills', entries);

      expect(outcome.isConfidentMatch, isTrue);
      expect(outcome.primary!.key, 'faq_arabic_needed_002');
    });

    test('distinguishes between entries with some overlapping vocabulary', () {
      final matcher = AiMentorMatcher();

      final outcome = matcher.match('is my prayer invalid if i make a mistake', entries);

      expect(outcome.primary!.key, 'faq_prayer_mistakes_003');
    });

    test('falls back gracefully for a question unrelated to any seed entry', () {
      final matcher = AiMentorMatcher();

      final outcome = matcher.match('what is the best pizza topping', entries);

      expect(outcome.isConfidentMatch, isFalse);
      expect(outcome.primary, isNull);
    });

    test('falls back gracefully for an empty query', () {
      final matcher = AiMentorMatcher();

      final outcome = matcher.match('', entries);

      expect(outcome.isConfidentMatch, isFalse);
      expect(outcome.related, isEmpty);
    });

    test('returns no results when there are no entries to match against', () {
      final matcher = AiMentorMatcher();

      final outcome = matcher.match('anything at all', const []);

      expect(outcome.primary, isNull);
      expect(outcome.related, isEmpty);
    });
  });
}
