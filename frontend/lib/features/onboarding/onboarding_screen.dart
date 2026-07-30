import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_spacing.dart';
import 'onboarding_repository.dart';

class _BackgroundOption {
  const _BackgroundOption(this.value, this.label, this.description);

  final String value;
  final String label;
  final String description;
}

const _options = [
  _BackgroundOption(
    'revert',
    'I have accepted Islam',
    "Welcome! Let's build your foundation together, one step at a time.",
  ),
  _BackgroundOption(
    'exploring',
    'I am exploring Islam',
    "No pressure at all — take your time to learn and ask questions.",
  ),
  _BackgroundOption(
    'raised_muslim',
    'I was raised Muslim',
    "We'll help you deepen and refresh what you already know.",
  ),
  _BackgroundOption(
    'other',
    'Something else',
    "That's okay — we'll start from the basics and go at your pace.",
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _selected;
  bool _isSaving = false;

  Future<void> _continue() async {
    if (_selected == null) return;

    setState(() => _isSaving = true);
    await ref.read(onboardingRepositoryProvider).complete(_selected!);

    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Text('Welcome to New Muslim Companion', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "To personalise your journey, tell us a little about where you're starting from.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView(
                  children: [
                    for (final option in _options)
                      Card(
                        color: _selected == option.value
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        child: ListTile(
                          title: Text(option.label),
                          subtitle: Text(option.description),
                          onTap: () => setState(() => _selected = option.value),
                          trailing: _selected == option.value ? const Icon(Icons.check_circle) : null,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selected == null || _isSaving ? null : _continue,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
