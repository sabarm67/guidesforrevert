import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Placeholder for the full Dua Library (organised by situation — morning,
/// travel, illness, etc). This phase seeds a handful of duas and shows
/// "today's dua" on the Home dashboard; the browsable library UI itself is
/// structure only in this phase.
class DuaLibraryPlaceholderScreen extends StatelessWidget {
  const DuaLibraryPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dua Library')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Text(
            'The full Dua Library, organised by situation, is coming soon.\n\n'
            "For now, see today's featured dua on the Home screen.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
