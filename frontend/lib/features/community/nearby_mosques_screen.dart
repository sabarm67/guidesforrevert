import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_spacing.dart';
import '../prayer/location_providers.dart';
import 'community_repository.dart';
import 'place_map.dart';

/// Finds nearby mosques/musallas via a live OpenStreetMap Overpass query,
/// centred on the same location used for prayer times. Requires an internet
/// connection — a deliberate, clearly-labelled exception to the app's
/// offline-first default, since this data can't reasonably be bundled.
class NearbyMosquesScreen extends ConsumerWidget {
  const NearbyMosquesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Mosques')),
      body: locationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not determine your location: $err')),
        data: (location) => _NearbyMosquesList(latitude: location.latitude, longitude: location.longitude),
      ),
    );
  }
}

class _NearbyMosquesList extends ConsumerWidget {
  const _NearbyMosquesList({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mosquesAsync = ref.watch(_nearbyMosquesProvider((latitude, longitude)));

    return mosquesAsync.when(
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
                'Could not reach OpenStreetMap. Finding nearby mosques needs an internet connection.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () => ref.invalidate(_nearbyMosquesProvider((latitude, longitude))),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      data: (mosques) {
        if (mosques.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: Text(
                'No mosques found nearby in OpenStreetMap\'s data for this area yet.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: mosques.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PlaceMap(
                  userLatitude: latitude,
                  userLongitude: longitude,
                  pinIcon: Icons.mosque,
                  pins: [
                    for (final mosque in mosques)
                      PlaceMapPin(
                        latitude: mosque.latitude,
                        longitude: mosque.longitude,
                        label: mosque.name,
                        onTap: () => _openInMaps(mosque),
                      ),
                  ],
                ),
              );
            }

            final mosque = mosques[index - 1];
            final distanceKm = mosque.distanceKmFrom(latitude, longitude);

            return Card(
              child: ListTile(
                leading: const Icon(Icons.mosque_outlined),
                title: Text(mosque.name),
                subtitle: mosque.address != null ? Text(mosque.address!) : null,
                trailing: Text('${distanceKm.toStringAsFixed(1)} km'),
                onTap: () => _openInMaps(mosque),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openInMaps(NearbyMosque mosque) async {
    final uri = Uri.parse(
      'https://www.openstreetmap.org/?mlat=${mosque.latitude}&mlon=${mosque.longitude}#map=17/${mosque.latitude}/${mosque.longitude}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

final _nearbyMosquesProvider = FutureProvider.family<List<NearbyMosque>, (double, double)>((ref, coords) {
  return ref.watch(communityRepositoryProvider).findNearbyMosques(latitude: coords.$1, longitude: coords.$2);
});
