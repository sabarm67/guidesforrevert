import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'quran_repository.dart';

class QuranBookmarksScreen extends ConsumerWidget {
  const QuranBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(_bookmarksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: bookmarksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not load bookmarks: $err')),
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'No bookmarks yet. Tap the bookmark icon on any ayah to save it here.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final entry = bookmarks[index];
              final colors = Theme.of(context).colorScheme;

              return Card(
                child: ListTile(
                  title: Text('${entry.surah.nameTransliteration} ${entry.ayah.numberInSurah}'),
                  subtitle: Text(
                    entry.ayah.translation,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(entry.surah.nameArabic, style: AppTypography.arabic(colors, size: 18)),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/quran/${entry.surah.number}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

final _bookmarksProvider = StreamProvider((ref) => ref.watch(quranRepositoryProvider).watchBookmarkedAyahs());
