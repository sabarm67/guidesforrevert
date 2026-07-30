import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Placeholder for the full Prayer module (animated Wudu, step-by-step
/// Salah, Friday/Eid/funeral/traveller prayer, etc. — see the product
/// brief's Prayer Module section). Only prayer *times* are implemented
/// this phase, shown on the Home dashboard; this screen is structure only.
class PrayerPlaceholderScreen extends StatelessWidget {
  const PrayerPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Text(
            'The full Prayer module — animated Wudu, step-by-step Salah, '
            'and prayer for special situations — is coming soon.\n\n'
            "For now, see today's prayer times on the Home screen.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
