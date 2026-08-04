import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_spacing.dart';
import 'location_providers.dart';
import 'prayer_times_service.dart';

/// Today's prayer times for the user's current location, with a location
/// picker. Shared by the Home dashboard and the Prayer tab.
class PrayerTimesCard extends ConsumerWidget {
  const PrayerTimesCard({super.key});

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
