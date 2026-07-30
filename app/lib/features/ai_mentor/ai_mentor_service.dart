import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ai_mentor_matcher.dart';
import 'ai_mentor_repository.dart';

/// One AI Mentor chat response: either a confident, cited answer, or an
/// honest fallback with related suggestions and a scholar-consult note.
/// See docs/ai-mentor/ai-mentor-design.md — there is no generative
/// composition step here, only retrieval, so this can never fabricate an
/// answer.
class MentorResponse {
  const MentorResponse({
    required this.question,
    required this.isConfidentMatch,
    this.record,
    this.relatedRecords = const [],
  });

  final String question;
  final bool isConfidentMatch;
  final AiFaqRecord? record;
  final List<AiFaqRecord> relatedRecords;

  static const fallbackMessage = "I'm not confident I have a good answer for that in my current library.";

  static const scholarDisclaimer =
      'This is general guidance from an offline library, not a personal '
      'religious ruling. For your specific situation, please consult a '
      'qualified scholar.';
}

class AiMentorService {
  AiMentorService(this._repository, this._matcher);

  final AiMentorRepository _repository;
  final AiMentorMatcher _matcher;

  Future<MentorResponse> ask(String question) async {
    final entries = await _repository.matchEntries();
    final outcome = _matcher.match(question, entries);

    if (outcome.primary != null) {
      final record = await _repository.recordByKey(outcome.primary!.key);
      final related = await Future.wait(outcome.related.map((e) => _repository.recordByKey(e.key)));

      return MentorResponse(
        question: question,
        isConfidentMatch: true,
        record: record,
        relatedRecords: related.whereType<AiFaqRecord>().toList(),
      );
    }

    final related = await Future.wait(outcome.related.map((e) => _repository.recordByKey(e.key)));

    return MentorResponse(
      question: question,
      isConfidentMatch: false,
      relatedRecords: related.whereType<AiFaqRecord>().toList(),
    );
  }
}

final aiMentorServiceProvider = Provider<AiMentorService>((ref) {
  return AiMentorService(ref.watch(aiMentorRepositoryProvider), AiMentorMatcher());
});
