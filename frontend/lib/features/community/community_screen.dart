import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'nearby_mosques_screen.dart';

/// Hub for community-facing features. Currently just "Nearby Mosques"
/// (a live OpenStreetMap Overpass lookup — see [NearbyMosquesScreen]);
/// structured as a hub so more sections (halal food/shops, a community
/// forum, etc.) can be added here later without restructuring the tab.
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
        ],
      ),
    );
  }
}
