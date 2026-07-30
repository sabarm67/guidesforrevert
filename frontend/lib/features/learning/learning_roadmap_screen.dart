import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../theme/app_spacing.dart';
import 'learning_repository.dart';

class LearningRoadmapScreen extends ConsumerWidget {
  const LearningRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(_stagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Learning Journey')),
      body: stagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not load your journey: $err')),
        data: (stages) => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: stages.length,
          itemBuilder: (context, index) => _StageCard(stage: stages[index]),
        ),
      ),
    );
  }
}

final _stagesProvider = StreamProvider((ref) => ref.watch(learningRepositoryProvider).watchStages());

class _StageCard extends ConsumerWidget {
  const _StageCard({required this.stage});

  final LearningStage stage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(_lessonsForStageProvider(stage.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stage ${stage.order}: ${stage.title}', style: Theme.of(context).textTheme.titleLarge),
            if (stage.description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(stage.description!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: AppSpacing.sm),
            lessonsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('$err'),
              data: (lessons) => Column(
                children: [
                  for (final lesson in lessons)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.menu_book_outlined),
                      title: Text(lesson.title),
                      subtitle: Text('${lesson.estimatedMinutes} min'),
                      onTap: () => context.push('/lesson/${lesson.id}'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final _lessonsForStageProvider = StreamProvider.family((ref, int stageId) {
  return ref.watch(learningRepositoryProvider).watchLessonsForStage(stageId);
});
