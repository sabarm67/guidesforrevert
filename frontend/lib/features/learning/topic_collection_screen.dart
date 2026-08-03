import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../theme/app_spacing.dart';
import 'learning_repository.dart';
import 'stage_card.dart';

/// Shows a standalone, non-linear topic collection (Fiqh in Daily Life,
/// Understanding Islam: Addressing Misconceptions) — reuses the same
/// [StageCard]/[LessonTile] widgets as the Learning Journey, but without
/// stage numbering, since these collections aren't a sequential path.
class TopicCollectionScreen extends ConsumerWidget {
  const TopicCollectionScreen({super.key, required this.collectionType, required this.title});

  final String collectionType;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(_stagesByCollectionProvider(collectionType));

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: stagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not load this section: $err')),
        data: (stages) {
          if (stages.isEmpty) {
            return const Center(child: Text('No content available yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: stages.length,
            itemBuilder: (context, index) => StageCard(stage: stages[index], showStageNumber: false),
          );
        },
      ),
    );
  }
}

final _stagesByCollectionProvider = StreamProvider.family<List<LearningStage>, String>((ref, collectionType) {
  return ref.watch(learningRepositoryProvider).watchStagesByCollection(collectionType);
});
