import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_spacing.dart';
import 'journal_repository.dart';

/// Handles both creating a new entry (`entryId == null`) and editing an
/// existing one, so the router only needs one screen for `/journal/new`
/// and `/journal/:id`.
class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({super.key, this.entryId});

  final int? entryId;

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _loaded = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _loadExisting() async {
    if (widget.entryId == null || _loaded) return;
    final entry = await ref.read(journalRepositoryProvider).entryById(widget.entryId!);
    if (entry != null && mounted) {
      _titleController.text = entry.title ?? '';
      _bodyController.text = entry.body;
    }
    _loaded = true;
  }

  Future<void> _save() async {
    final body = _bodyController.text.trim();
    if (body.isEmpty) return;

    final title = _titleController.text.trim();
    final repository = ref.read(journalRepositoryProvider);

    if (widget.entryId == null) {
      await repository.createEntry(title: title.isEmpty ? null : title, body: body);
    } else {
      await repository.updateEntry(widget.entryId!, title: title.isEmpty ? null : title, body: body);
    }

    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    if (widget.entryId == null) return;
    await ref.read(journalRepositoryProvider).deleteEntry(widget.entryId!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadExisting(),
      builder: (context, snapshot) {
        if (widget.entryId != null && snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.entryId == null ? 'New Entry' : 'Edit Entry'),
            actions: [
              if (widget.entryId != null)
                IconButton(icon: const Icon(Icons.delete_outline), onPressed: _delete),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title (optional)'),
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _bodyController,
                    decoration: const InputDecoration(
                      labelText: 'What\'s on your mind?',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(onPressed: _save, child: const Text('Save')),
              ],
            ),
          ),
        );
      },
    );
  }
}
