import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_spacing.dart';
import 'ai_mentor_repository.dart';
import 'ai_mentor_service.dart';

class _ChatTurn {
  _ChatTurn.user(this.text) : isUser = true, response = null;
  _ChatTurn.mentor(MentorResponse mentorResponse)
    : isUser = false,
      text = mentorResponse.question,
      response = mentorResponse;

  final bool isUser;
  final String text;
  final MentorResponse? response;
}

class AiMentorScreen extends ConsumerStatefulWidget {
  const AiMentorScreen({super.key});

  @override
  ConsumerState<AiMentorScreen> createState() => _AiMentorScreenState();
}

class _AiMentorScreenState extends ConsumerState<AiMentorScreen> {
  final _controller = TextEditingController();
  final _turns = <_ChatTurn>[];
  bool _isThinking = false;

  Future<void> _submit() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _turns.add(_ChatTurn.user(question));
      _isThinking = true;
      _controller.clear();
    });

    final service = ref.read(aiMentorServiceProvider);
    final response = await service.ask(question);

    if (!mounted) return;

    setState(() {
      _turns.add(_ChatTurn.mentor(response));
      _isThinking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Mentor')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              MentorResponse.scholarDisclaimer,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          Expanded(
            child: _turns.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Text('Ask a beginner question — e.g. "Do I need to know Arabic right away?"'),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _turns.length,
                    itemBuilder: (context, index) => _TurnBubble(turn: _turns[index]),
                  ),
          ),
          if (_isThinking)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: LinearProgressIndicator(),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type your question…',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(onPressed: _isThinking ? null : _submit, icon: const Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TurnBubble extends StatelessWidget {
  const _TurnBubble({required this.turn});

  final _ChatTurn turn;

  @override
  Widget build(BuildContext context) {
    if (turn.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Text(turn.text)),
        ),
      );
    }

    final response = turn.response!;

    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (response.isConfidentMatch && response.record != null) ...[
                Text(response.record!.answerText),
                if (response.record!.requiresScholarDisclaimer) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    MentorResponse.scholarDisclaimer,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
                if (response.record!.citations.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _SourcesSection(citations: response.record!.citations),
                ],
              ] else ...[
                Text(MentorResponse.fallbackMessage),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  MentorResponse.scholarDisclaimer,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
                if (response.relatedRecords.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text('You might find these related:', style: Theme.of(context).textTheme.titleMedium),
                  for (final related in response.relatedRecords)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text('• ${related.canonicalQuestion}'),
                    ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SourcesSection extends StatefulWidget {
  const _SourcesSection({required this.citations});

  final List<SourceCitation> citations;

  @override
  State<_SourcesSection> createState() => _SourcesSectionState();
}

class _SourcesSectionState extends State<_SourcesSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _expanded = !_expanded),
          icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          label: const Text('Sources'),
        ),
        if (_expanded)
          for (final citation in widget.citations)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Text('• ${citation.label}'),
            ),
      ],
    );
  }
}
