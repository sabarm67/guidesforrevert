import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/arabic_text_fixes.dart';
import 'learning_repository.dart';

class LessonScreen extends ConsumerWidget {
  const LessonScreen({super.key, required this.lessonId});

  final int lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(learningRepositoryProvider);
    final progressAsync = ref.watch(_lessonProgressProvider(lessonId));

    return FutureBuilder(
      future: repository.lessonById(lessonId),
      builder: (context, snapshot) {
        final lesson = snapshot.data;
        if (lesson == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final blocks = repository.decodeBody(lesson);
        final isCompleted = progressAsync.valueOrNull?.status == 'completed';

        return Scaffold(
          appBar: AppBar(title: Text(lesson.title)),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (lesson.summary != null) ...[
                Text(lesson.summary!, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.md),
              ],
              for (final block in blocks) _LessonBlock(block: block),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: isCompleted
                    ? null
                    : () => ref.read(learningRepositoryProvider).markLessonStatus(lessonId, 'completed'),
                icon: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
                label: Text(isCompleted ? 'Completed' : 'Mark Complete'),
              ),
            ],
          ),
        );
      },
    );
  }
}

final _lessonProgressProvider = StreamProvider.family((ref, int lessonId) {
  return ref.watch(learningRepositoryProvider).watchProgress(lessonId);
});

class _LessonBlock extends StatelessWidget {
  const _LessonBlock({required this.block});

  final Map<String, dynamic> block;

  @override
  Widget build(BuildContext context) {
    final type = block['type'] as String?;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    switch (type) {
      case 'heading':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(block['text'] as String? ?? '', style: textTheme.titleLarge),
        );
      case 'text':
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Text(block['text'] as String? ?? '', style: textTheme.bodyLarge),
        );
      case 'quote':
        return Card(
          color: colors.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (block['arabic'] != null)
                  Text(
                    hideBrokenAnnotationMarks(block['arabic'] as String),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: AppTypography.arabic(colors),
                  ),
                if (block['transliteration'] != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    block['transliteration'] as String,
                    style: textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Text(block['translation'] as String? ?? '', style: textTheme.bodyLarge),
                if (block['reference'] != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(block['reference'] as String, style: textTheme.labelSmall),
                ],
              ],
            ),
          ),
        );
      case 'image':
        final ref = block['image_ref'] as String?;
        if (ref == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                child: ref.endsWith('.svg')
                    ? SvgPicture.asset(ref, width: 180, height: 180)
                    : Image.asset(ref, width: 180, height: 180, fit: BoxFit.contain),
              ),
              if (block['caption'] != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  block['caption'] as String,
                  style: textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      case 'faq':
        return Card(
          child: ExpansionTile(
            title: Text(block['question'] as String? ?? '', style: textTheme.titleMedium),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(block['answer'] as String? ?? ''),
              ),
            ],
          ),
        );
      case 'reflection':
        return Card(
          color: colors.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.self_improvement, color: colors.onSecondaryContainer),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(block['question'] as String? ?? '')),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
