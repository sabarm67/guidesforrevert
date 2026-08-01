import 'package:flutter/material.dart';

import '../theme/app_spacing.dart' show AppBreakpoints;

/// Hand-rolled adaptive navigation shell: `NavigationBar` on compact
/// widths (phones), `NavigationRail` on medium/expanded widths
/// (tablet/desktop/web), switching at Material 3's documented breakpoints.
/// `flutter_adaptive_scaffold` was considered but is discontinued (no
/// maintenance path), so this small widget avoids that dependency — see
/// docs/design-system/design-tokens.md.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  static const _destinations = [
    _ShellDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
    _ShellDestination(icon: Icons.menu_book_outlined, selectedIcon: Icons.menu_book, label: 'Learning'),
    _ShellDestination(icon: Icons.mosque_outlined, selectedIcon: Icons.mosque, label: 'Prayer'),
    _ShellDestination(icon: Icons.auto_stories_outlined, selectedIcon: Icons.auto_stories, label: 'Duas'),
    _ShellDestination(icon: Icons.groups_outlined, selectedIcon: Icons.groups, label: 'Community'),
    _ShellDestination(icon: Icons.edit_note_outlined, selectedIcon: Icons.edit_note, label: 'Journal'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWideLayout = width >= AppBreakpoints.medium;

    if (isWideLayout) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          for (final d in _destinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.label,
              tooltip: d.label,
            ),
        ],
      ),
    );
  }
}

class _ShellDestination {
  const _ShellDestination({required this.icon, required this.selectedIcon, required this.label});

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
