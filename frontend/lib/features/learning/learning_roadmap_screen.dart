import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          itemCount: stages.length,
          itemBuilder: (context, index) => StageCard(stage: stages[index]),
        ),
      ),
    );
  }
}

final _stagesProvider = StreamProvider((ref) => ref.watch(learningRepositoryProvider).watchStages());
