import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_spacing.dart';
import '../duas/dua_library_screen.dart';
import '../learning/learning_repository.dart';
import '../learning/stage_card.dart';
import 'prayer_times_card.dart';

/// Prayer tab: today's prayer times, a Duas subsection (see
/// [DuaLibraryCard] — lives here rather than on the Quran tab, since duas
/// are used in the context of daily prayer and worship), plus the "Prayer
/// Guide" content collection (full Wudu/Salah step-by-step guides and an
/// overview of the different kinds of prayer) — see [TopicCollectionScreen]
/// for the same pattern used by Fiqh in Daily Life and Understanding Islam.
class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesAsync = ref.watch(_prayerGuideStagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const PrayerTimesCard(),
          const SizedBox(height: AppSpacing.lg),
          Text('Duas', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          const DuaLibraryCard(),
          const SizedBox(height: AppSpacing.lg),
          stagesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Could not load the prayer guide: $err'),
            data: (stages) => Column(
              children: [
                for (final stage in stages) StageCard(stage: stage, showStageNumber: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final _prayerGuideStagesProvider = StreamProvider((ref) {
  return ref.watch(learningRepositoryProvider).watchStagesByCollection('prayer_guide');
});
