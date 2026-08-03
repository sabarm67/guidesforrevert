import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../theme/app_spacing.dart';
import 'learning_repository.dart';

/// Shown as "Stage N: Title" when [showStageNumber] is true (the linear
/// Learning Journey), or just "Title" for standalone topic collections
/// (Fiqh, Understanding Islam) where a stage number wouldn't mean anything.
class StageCard extends ConsumerWidget {
  const StageCard({super.key, required this.stage, this.showStageNumber = true});

  final LearningStage stage;
  final bool showStageNumber;

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
                    showStageNumber ? 'Stage ${stage.order}: ${stage.title}' : stage.title,
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
                children: [for (final lesson in lessons) LessonTile(lesson: lesson)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonTile extends ConsumerWidget {
  const LessonTile({super.key, required this.lesson});

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
