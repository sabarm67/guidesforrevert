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
    final progressAsync = ref.watch(_stageProgressProvider(stage.id));
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Stage ${stage.order}: ${stage.title}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                progressAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (err, _) => const SizedBox.shrink(),
                  data: (progress) {
                    final (completed, total) = progress;
                    if (total == 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: Text(
                        '$completed/$total',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ],
            ),
            if (stage.description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(stage.description!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: AppSpacing.xs),
            progressAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (err, _) => const SizedBox.shrink(),
              data: (progress) {
                final (completed, total) = progress;
                if (total == 0) return const SizedBox.shrink();
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                  child: LinearProgressIndicator(value: completed / total, minHeight: 6),
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            lessonsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('$err'),
              data: (lessons) => Column(
                children: [for (final lesson in lessons) _LessonTile(lesson: lesson)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonTile extends ConsumerWidget {
  const _LessonTile({required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(_lessonProgressProvider(lesson.id));
    final isCompleted = progressAsync.valueOrNull?.status == 'completed';
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.menu_book_outlined,
        color: isCompleted ? colors.primary : null,
      ),
      title: Text(
        lesson.title,
        style: isCompleted ? TextStyle(color: colors.onSurfaceVariant) : null,
      ),
      subtitle: Text('${lesson.estimatedMinutes} min'),
      onTap: () => context.push('/lesson/${lesson.id}'),
    );
  }
}

final _lessonsForStageProvider = StreamProvider.family((ref, int stageId) {
  return ref.watch(learningRepositoryProvider).watchLessonsForStage(stageId);
});

final _stageProgressProvider = StreamProvider.family((ref, int stageId) {
  return ref.watch(learningRepositoryProvider).watchStageProgress(stageId);
});

final _lessonProgressProvider = StreamProvider.family((ref, int lessonId) {
  return ref.watch(learningRepositoryProvider).watchProgress(lessonId);
});
