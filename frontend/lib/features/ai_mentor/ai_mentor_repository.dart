import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/providers.dart';
import 'ai_mentor_matcher.dart';

class SourceCitation {
  const SourceCitation({required this.type, required this.label, this.id, this.collection, this.number});

  final String type;
  final String label;
  final String? id;
  final String? collection;
  final int? number;

  factory SourceCitation.fromJson(Map<String, dynamic> json) => SourceCitation(
    type: json['type'] as String,
    label: json['label'] as String,
    id: json['id'] as String?,
    collection: json['collection'] as String?,
    number: json['number'] as int?,
  );
}

/// The full FAQ entry, including the answer and citations — the
/// [AiMentorMatcher] only needs the lightweight [FaqMatchEntry] shape for
/// scoring, but the UI needs this full record for whichever entry wins.
class AiFaqRecord {
  const AiFaqRecord({
    required this.key,
    required this.canonicalQuestion,
    required this.answerText,
    required this.category,
    required this.citations,
    required this.confidence,
    required this.requiresScholarDisclaimer,
  });

  final String key;
  final String canonicalQuestion;
  final String answerText;
  final String category;
  final List<SourceCitation> citations;
  final String confidence;
  final bool requiresScholarDisclaimer;
}

class AiMentorRepository {
  AiMentorRepository(this._db);

  final AppDatabase _db;

  Future<List<AiFaqEntry>> _allEntries() => _db.select(_db.aiFaqEntries).get();

  Future<List<FaqMatchEntry>> matchEntries() async {
    final rows = await _allEntries();

    return rows
        .map(
          (row) => FaqMatchEntry(
            key: row.faqKey,
            canonicalQuestion: row.canonicalQuestion,
            questionVariants: (jsonDecode(row.questionVariantsJson) as List).cast<String>(),
            keywords: (jsonDecode(row.keywordsJson) as List).cast<String>(),
          ),
        )
        .toList();
  }

  Future<AiFaqRecord?> recordByKey(String key) async {
    final row = await (_db.select(_db.aiFaqEntries)..where((t) => t.faqKey.equals(key))).getSingleOrNull();

    if (row == null) return null;

    return _toRecord(row);
  }

  AiFaqRecord _toRecord(AiFaqEntry row) {
    final citationsJson = (jsonDecode(row.sourceCitationsJson) as List).cast<Map<String, dynamic>>();

    return AiFaqRecord(
      key: row.faqKey,
      canonicalQuestion: row.canonicalQuestion,
      answerText: row.answerText,
      category: row.category,
      citations: citationsJson.map(SourceCitation.fromJson).toList(),
      confidence: row.confidence,
      requiresScholarDisclaimer: row.requiresScholarDisclaimer,
    );
  }
}

final aiMentorRepositoryProvider = Provider<AiMentorRepository>((ref) {
  return AiMentorRepository(ref.watch(appDatabaseProvider));
});
