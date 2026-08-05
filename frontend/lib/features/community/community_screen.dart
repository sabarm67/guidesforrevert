import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'halal_food_screen.dart';
import 'nearby_mosques_screen.dart';

/// Hub for community-facing features: "Nearby Mosques" and "Halal Food
/// Finder" today (both live OpenStreetMap Overpass lookups — see
/// [NearbyMosquesScreen]/[HalalFoodScreen]), structured as a hub so more
/// sections (a community forum, etc.) can be added here later without
/// restructuring the tab.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.mosque_outlined),
              title: const Text('Nearby Mosques'),
              subtitle: const Text('Find mosques and musallas near your location'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const NearbyMosquesScreen())),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.restaurant_outlined),
              title: const Text('Halal Food Finder'),
              subtitle: const Text('Find halal restaurants, shops, and butchers near you'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HalalFoodScreen())),
            ),
          ),
        ],
      ),
    );
  }
}
