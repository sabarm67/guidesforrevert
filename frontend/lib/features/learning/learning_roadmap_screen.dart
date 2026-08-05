import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_spacing.dart';
import 'learning_repository.dart';
import 'stage_card.dart';

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
          itemCount: stages.length + 1,
          itemBuilder: (context, index) {
            if (index == stages.length) {
              return const Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: _ExploreMoreCard(),
              );
            }

            return StageCard(stage: stages[index]);
          },
        ),
      ),
    );
  }
}

/// Standalone, non-linear topic collections (Fiqh, Understanding Islam,
/// Comparing Faiths) — not part of the 4-stage Learning Journey above, but
/// grouped here on the Learning page rather than on Home, since they're
/// all learning content just outside the linear stage progression.
class _ExploreMoreCard extends StatelessWidget {
  const _ExploreMoreCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Explore More', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.gavel_outlined),
              title: const Text('Fiqh in Daily Life'),
              subtitle: const Text('How Islamic jurisprudence applies to real decisions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/fiqh'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.forum_outlined),
              title: const Text('Understanding Islam'),
              subtitle: const Text('Honest answers to common fears and misconceptions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/misconceptions'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.balance_outlined),
              title: const Text('Comparing Faiths'),
              subtitle: const Text('For reverts from Christianity: shared ground and honest differences'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/comparisons'),
            ),
          ],
        ),
      ),
    );
  }
}

final _stagesProvider = StreamProvider((ref) => ref.watch(learningRepositoryProvider).watchStages());
