import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/db/app_database.dart';
import '../../theme/app_spacing.dart';
import 'journal_repository.dart';

class JournalListScreen extends ConsumerWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(_entriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/journal/new'),
        child: const Icon(Icons.add),
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not load your journal: $err')),
        data: (entries) {
          if (entries.isEmpty) {
            return const _EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: entries.length,
            itemBuilder: (context, index) => _JournalEntryCard(entry: entries[index]),
          );
        },
      ),
    );
  }
}

final _entriesProvider = StreamProvider((ref) => ref.watch(journalRepositoryProvider).watchEntries());

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_stories_outlined, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Your journal is empty. Tap + to write your first reflection — this stays on your device only.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  const _JournalEntryCard({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat.yMMMd().add_jm().format(entry.createdAt);
    final snippet = entry.body.length > 120 ? '${entry.body.substring(0, 120)}…' : entry.body;

    return Card(
      child: ListTile(
        title: Text(entry.title?.isNotEmpty == true ? entry.title! : dateLabel),
        subtitle: Text(snippet, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () => context.push('/journal/${entry.id}'),
      ),
    );
  }
}
