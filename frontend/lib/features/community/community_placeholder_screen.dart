import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Placeholder for the Community directory (nearby mosques, musallas,
/// halal restaurants/shops, via OpenStreetMap). Not built this phase — see
/// docs/architecture/system-architecture.md for what's implemented vs
/// planned.
class CommunityPlaceholderScreen extends StatelessWidget {
  const CommunityPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Text(
            'Finding nearby mosques, musallas, and halal shops is coming soon.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
