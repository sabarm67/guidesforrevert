import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_spacing.dart';
import '../prayer/location_providers.dart';
import 'community_repository.dart';
import 'place_map.dart';

/// Finds nearby halal restaurants, shops, and butchers via a live
/// OpenStreetMap Overpass query, centred on the same location used for
/// prayer times. Requires an internet connection — same deliberate,
/// clearly-labelled exception to the app's offline-first default as the
/// Nearby Mosques screen it's modelled on.
class HalalFoodScreen extends ConsumerWidget {
  const HalalFoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Halal Food Finder')),
      body: locationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not determine your location: $err')),
        data: (location) => _HalalFoodList(latitude: location.latitude, longitude: location.longitude),
      ),
    );
  }
}

class _HalalFoodList extends ConsumerWidget {
  const _HalalFoodList({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(_halalFoodProvider((latitude, longitude)));

    return placesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_outlined, size: 48),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Could not reach OpenStreetMap. Finding halal food nearby needs an internet connection.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () => ref.invalidate(_halalFoodProvider((latitude, longitude))),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      data: (places) {
        if (places.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: Text(
                'No halal-tagged restaurants or shops found nearby in OpenStreetMap\'s data '
                'for this area yet. Coverage depends on volunteer mapping, so it varies by region.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: places.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PlaceMap(
                  userLatitude: latitude,
                  userLongitude: longitude,
                  pinIcon: Icons.restaurant,
                  pins: [
                    for (final place in places)
                      PlaceMapPin(
                        latitude: place.latitude,
                        longitude: place.longitude,
                        label: place.name,
                        onTap: () => _openInMaps(place),
                      ),
                  ],
                ),
              );
            }

            final place = places[index - 1];
            final distanceKm = place.distanceKmFrom(latitude, longitude);

            return Card(
              child: ListTile(
                leading: const Icon(Icons.restaurant_outlined),
                title: Text(place.name),
                subtitle: Text(
                  place.address != null ? '${place.category} · ${place.address}' : place.category,
                ),
                trailing: Text('${distanceKm.toStringAsFixed(1)} km'),
                onTap: () => _openInMaps(place),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openInMaps(HalalFoodPlace place) async {
    final uri = Uri.parse(
      'https://www.openstreetmap.org/?mlat=${place.latitude}&mlon=${place.longitude}#map=17/${place.latitude}/${place.longitude}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

final _halalFoodProvider = FutureProvider.family<List<HalalFoodPlace>, (double, double)>((ref, coords) {
  return ref.watch(communityRepositoryProvider).findHalalFood(latitude: coords.$1, longitude: coords.$2);
});
