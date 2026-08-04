import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../ai_mentor/ai_mentor_screen.dart';
import '../duas/daily_dua_provider.dart';
import '../learning/learning_repository.dart';
import '../prayer/prayer_times_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Muslim Companion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined),
            tooltip: 'AI Mentor',
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AiMentorScreen())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: const [
          _ContinueLearningCard(),
          SizedBox(height: AppSpacing.md),
          PrayerTimesCard(),
          SizedBox(height: AppSpacing.md),
          _TodaysDuaCard(),
          SizedBox(height: AppSpacing.md),
          _ExploreMoreCard(),
        ],
      ),
    );
  }
}

class _ContinueLearningCard extends ConsumerWidget {
  const _ContinueLearningCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetAsync = ref.watch(continueLearningProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: targetAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (err, _) => Text('Could not load your journey: $err'),
          data: (target) {
            if (target == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Journey', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  const Text('Your lessons will appear here once content is ready.'),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stage ${target.stage.order}: ${target.stage.title}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  target.isNewLesson ? target.lesson.title : 'Revisit: ${target.lesson.title}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () => context.push('/lesson/${target.lesson.id}'),
                  child: const Text('Continue Learning'),
                ),
                TextButton(onPressed: () => context.push('/roadmap'), child: const Text('View full journey')),
              ],
            );
          },
        ),
      ),
    );
  }
}

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
          ],
        ),
      ),
    );
  }
}

class _TodaysDuaCard extends ConsumerWidget {
  const _TodaysDuaCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duaAsync = ref.watch(dailyDuaProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: duaAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (err, _) => Text('Could not load today\'s dua: $err'),
          data: (dua) {
            if (dua == null) {
              return const Text('No dua available yet.');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Dua", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  dua.arabicText,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: AppTypography.arabic(Theme.of(context).colorScheme),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(dua.translation, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(dua.reference, style: Theme.of(context).textTheme.labelSmall),
              ],
            );
          },
        ),
      ),
    );
  }
}
