import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/arabic_text_fixes.dart';
import 'quran_repository.dart';

/// Searches ayah Arabic text and English translation for a phrase or
/// sentence, entirely offline (see QuranRepository.searchAyahs). Reachable
/// via the search icon on the Quran tab's surah list.
class QuranSearchScreen extends ConsumerStatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  ConsumerState<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends ConsumerState<QuranSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(_searchProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search the Quran…',
            border: InputBorder.none,
          ),
          onChanged: _onChanged,
        ),
      ),
      body: _query.trim().isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Search for a word or phrase across the Arabic text and English translation of every ayah.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : resultsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Search failed: $err')),
              data: (results) {
                if (results.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Text('No ayahs found for this search.', textAlign: TextAlign.center),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: results.length,
                  itemBuilder: (context, index) => _SearchResultTile(result: results[index]),
                );
              },
            ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.result});

  final ({Ayah ayah, Surah surah}) result;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        title: Text('${result.surah.nameTransliteration} ${result.ayah.numberInSurah}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(
              hideBrokenAnnotationMarks(result.ayah.arabicText),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.arabic(colors, size: 18),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(result.ayah.translation, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          Navigator.of(context).pop();
          context.push('/quran/${result.surah.number}');
        },
      ),
    );
  }
}

final _searchProvider = FutureProvider.family<List<({Ayah ayah, Surah surah})>, String>((ref, query) {
  return ref.watch(quranRepositoryProvider).searchAyahs(query);
});
