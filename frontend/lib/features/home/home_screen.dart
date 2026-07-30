import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../ai_mentor/ai_mentor_screen.dart';
import '../duas/daily_dua_provider.dart';
import '../learning/learning_repository.dart';
import '../prayer/location_providers.dart';
import '../prayer/prayer_times_service.dart';

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
          _PrayerTimesCard(),
          SizedBox(height: AppSpacing.md),
          _TodaysDuaCard(),
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

class _PrayerTimesCard extends ConsumerWidget {
  const _PrayerTimesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationControllerProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: locationAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (err, _) => Text('Could not determine prayer times: $err'),
          data: (location) {
            const service = PrayerTimesService();
            final times = service.calculate(latitude: location.latitude, longitude: location.longitude);
            final next = times.next(DateTime.now());

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Prayer Times', style: Theme.of(context).textTheme.titleMedium),
                    TextButton.icon(
                      onPressed: () => _showLocationPicker(context, ref),
                      icon: const Icon(Icons.location_on_outlined, size: 18),
                      label: Text(location.label),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Next: ${next.key} at ${TimeOfDay.fromDateTime(next.value).format(context)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final entry in times.ordered)
                      Chip(
                        label: Text('${entry.key} ${TimeOfDay.fromDateTime(entry.value).format(context)}'),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showLocationPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.my_location),
              title: const Text('Use my device location'),
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(locationControllerProvider.notifier).useDeviceLocation();
              },
            ),
            const Divider(height: 1),
            for (final city in knownCities)
              ListTile(
                title: Text(city.name),
                onTap: () async {
                  Navigator.of(context).pop();
                  await ref.read(locationControllerProvider.notifier).selectCity(city);
                },
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
