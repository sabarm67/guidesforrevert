import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'quran_repository.dart';

/// One surah's full ayah list — Arabic + Pickthall translation per ayah,
/// each with a bookmark toggle and a personal note.
class SurahDetailScreen extends ConsumerWidget {
  const SurahDetailScreen({super.key, required this.surahNumber});

  final int surahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahAsync = ref.watch(_surahProvider(surahNumber));

    return Scaffold(
      appBar: AppBar(title: Text(surahAsync.valueOrNull?.nameTransliteration ?? 'Surah')),
      body: surahAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not load this surah: $err')),
        data: (surah) {
          if (surah == null) {
            return const Center(child: Text('Surah not found.'));
          }

          return _AyahList(surahId: surah.id);
        },
      ),
    );
  }
}

class _AyahList extends ConsumerWidget {
  const _AyahList({required this.surahId});

  final int surahId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahsAsync = ref.watch(_ayahsProvider(surahId));

    return ayahsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Could not load ayahs: $err')),
      data: (ayahs) => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: ayahs.length,
        separatorBuilder: (context, index) => const Divider(height: AppSpacing.xl),
        itemBuilder: (context, index) => _AyahTile(ayah: ayahs[index]),
      ),
    );
  }
}

class _AyahTile extends ConsumerWidget {
  const _AyahTile({required this.ayah});

  final Ayah ayah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isBookmarkedAsync = ref.watch(_isBookmarkedProvider(ayah.id));
    final noteAsync = ref.watch(_noteProvider(ayah.id));
    final isBookmarked = isBookmarkedAsync.valueOrNull ?? false;
    final hasNote = (noteAsync.valueOrNull?.noteText.isNotEmpty ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: colors.surfaceContainerHighest,
              child: Text('${ayah.numberInSurah}', style: Theme.of(context).textTheme.labelSmall),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    hasNote ? Icons.edit_note : Icons.note_add_outlined,
                    color: hasNote ? colors.primary : null,
                  ),
                  tooltip: hasNote ? 'Edit note' : 'Add note',
                  onPressed: () => _showNoteSheet(context, ref, ayah.id, noteAsync.valueOrNull?.noteText ?? ''),
                ),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                    color: isBookmarked ? colors.primary : null,
                  ),
                  tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark this ayah',
                  onPressed: () => ref.read(quranRepositoryProvider).toggleBookmark(ayah.id),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          ayah.arabicText,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: AppTypography.arabic(colors),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(ayah.translation, style: Theme.of(context).textTheme.bodyLarge),
        if (hasNote) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
            child: Text(
              noteAsync.valueOrNull!.noteText,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.onSecondaryContainer),
            ),
          ),
        ],
      ],
    );
  }

  void _showNoteSheet(BuildContext context, WidgetRef ref, int ayahId, String existingText) {
    final controller = TextEditingController(text: existingText);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Your Note', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: controller,
              maxLines: 5,
              autofocus: true,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Write a reflection...'),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (existingText.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      ref.read(quranRepositoryProvider).deleteNote(ayahId);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Delete'),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isEmpty) {
                      ref.read(quranRepositoryProvider).deleteNote(ayahId);
                    } else {
                      ref.read(quranRepositoryProvider).upsertNote(ayahId, text);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final _surahProvider = FutureProvider.family<Surah?, int>((ref, number) {
  return ref.watch(quranRepositoryProvider).surahByNumber(number);
});

final _ayahsProvider = StreamProvider.family<List<Ayah>, int>((ref, surahId) {
  return ref.watch(quranRepositoryProvider).watchAyahsForSurah(surahId);
});

final _isBookmarkedProvider = StreamProvider.family<bool, int>((ref, ayahId) {
  return ref.watch(quranRepositoryProvider).watchIsBookmarked(ayahId);
});

final _noteProvider = StreamProvider.family<AyahNote?, int>((ref, ayahId) {
  return ref.watch(quranRepositoryProvider).watchNoteForAyah(ayahId);
});
