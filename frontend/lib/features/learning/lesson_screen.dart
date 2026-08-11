import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/arabic_text_fixes.dart';
import 'learning_repository.dart';

/// Groups consecutive 'image' body blocks so they can be laid out together
/// (side by side on wide screens) instead of one per list row.
List<Widget> _lessonBlockWidgets(List<Map<String, dynamic>> blocks) {
  final widgets = <Widget>[];
  var i = 0;
  while (i < blocks.length) {
    if (blocks[i]['type'] == 'image') {
      final group = <Map<String, dynamic>>[];
      while (i < blocks.length && blocks[i]['type'] == 'image') {
        group.add(blocks[i]);
        i++;
      }
      widgets.add(_LessonImageGroup(images: group));
    } else {
      widgets.add(_LessonBlock(block: blocks[i]));
      i++;
    }
  }
  return widgets;
}

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
              ..._lessonBlockWidgets(blocks),
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
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _LessonImage(block: block, maxHeight: 320),
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

/// Lays out a run of consecutive image blocks (e.g. front/side/back views of
/// one posture) side by side when there's room, stacked otherwise — rather
/// than hard-coding a screen-width breakpoint, it just measures the space
/// actually available in the lesson body.
class _LessonImageGroup extends StatelessWidget {
  const _LessonImageGroup({required this.images});

  final List<Map<String, dynamic>> images;

  @override
  Widget build(BuildContext context) {
    const spacing = AppSpacing.md;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final perItemWidth =
              (constraints.maxWidth - spacing * (images.length - 1)) / images.length;
          final sideBySide = images.length > 1 && perItemWidth >= 160;

          if (sideBySide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < images.length; i++) ...[
                  if (i > 0) const SizedBox(width: spacing),
                  Expanded(child: _LessonImage(block: images[i], maxHeight: 280)),
                ],
              ],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < images.length; i++) ...[
                if (i > 0) const SizedBox(height: spacing),
                _LessonImage(block: images[i], maxHeight: 320),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _LessonImage extends StatelessWidget {
  const _LessonImage({required this.block, required this.maxHeight});

  final Map<String, dynamic> block;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final ref = block['image_ref'] as String?;
    if (ref == null) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: ref.endsWith('.svg')
                ? SvgPicture.asset(ref, fit: BoxFit.contain)
                : Image.asset(ref, fit: BoxFit.contain),
          ),
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
    );
  }
}
