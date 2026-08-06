import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/arabic_text_fixes.dart';
import '../duas/dua_library_screen.dart';
import 'quran_bookmarks_screen.dart';
import 'quran_repository.dart';

/// Primary view of the "Quran & Duas" tab: the full 114-surah directory,
/// so a user can jump straight into reading without going through the
/// Learning Journey. The Dua Library lives as a secondary section below
/// the surah list within this same tab (see [DuaLibraryScreen]).
class QuranSurahListScreen extends ConsumerWidget {
  const QuranSurahListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(_surahsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran & Duas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'Bookmarks',
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const QuranBookmarksScreen())),
          ),
        ],
      ),
      body: surahsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not load the Quran: $err')),
        data: (surahs) {
          if (surahs.isEmpty) {
            return const Center(child: Text('No Quran content available yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: surahs.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'The Quran',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }

              if (index == surahs.length + 1) {
                return const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.lg),
                  child: DuaLibraryCard(),
                );
              }

              final surah = surahs[index - 1];
              return _SurahTile(surah: surah);
            },
          );
        },
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  const _SurahTile({required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors.primaryContainer,
          child: Text('${surah.number}', style: TextStyle(color: colors.onPrimaryContainer)),
        ),
        title: Text('${surah.nameTransliteration} — ${surah.nameEnglish}'),
        subtitle: Text(
          '${surah.ayahCount} ayahs · ${surah.revelationType == 'meccan' ? 'Meccan' : 'Medinan'}',
        ),
        trailing: Text(hideBrokenAnnotationMarks(surah.nameArabic), style: AppTypography.arabic(colors, size: 20)),
        onTap: () => context.push('/quran/${surah.number}'),
      ),
    );
  }
}

final _surahsProvider = StreamProvider((ref) => ref.watch(quranRepositoryProvider).watchSurahs());
