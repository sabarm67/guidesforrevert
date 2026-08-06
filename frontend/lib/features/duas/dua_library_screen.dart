import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../theme/arabic_text_fixes.dart';
import 'dua_repository.dart';

/// A compact "Explore" card shown below the surah list on the Quran & Duas
/// tab (see QuranSurahListScreen) — pushes the full [DuaLibraryScreen].
class DuaLibraryCard extends StatelessWidget {
  const DuaLibraryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.auto_stories_outlined),
        title: const Text('Dua Library'),
        subtitle: const Text('Browse duas by situation — morning, eating, distress, and more'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DuaLibraryScreen())),
      ),
    );
  }
}

class DuaLibraryScreen extends ConsumerWidget {
  const DuaLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(_categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dua Library')),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Could not load duas: $err')),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No duas available yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: categories.length,
            itemBuilder: (context, index) => _CategorySection(category: categories[index]),
          );
        },
      ),
    );
  }
}

class _CategorySection extends ConsumerWidget {
  const _CategorySection({required this.category});

  final DuaCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duasAsync = ref.watch(_duasForCategoryProvider(category.id));

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            duasAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('$err'),
              data: (duas) => Column(
                children: [for (final dua in duas) _DuaTile(dua: dua)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DuaTile extends StatelessWidget {
  const _DuaTile({required this.dua});

  final Dua dua;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(dua.title),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            hideBrokenAnnotationMarks(dua.arabicText),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppTypography.arabic(colors, size: 20),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(dua.transliteration, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
        const SizedBox(height: AppSpacing.sm),
        Text(dua.translation, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.xs),
        Text(dua.reference, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

final _categoriesProvider = StreamProvider((ref) => ref.watch(duaRepositoryProvider).watchCategories());

final _duasForCategoryProvider = StreamProvider.family<List<Dua>, int>((ref, categoryId) {
  return ref.watch(duaRepositoryProvider).watchDuasForCategory(categoryId);
});
