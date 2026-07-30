import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'seed_importer.dart';

/// Single shared [AppDatabase] instance for the app's lifetime.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Runs [SeedImporter.importIfNeeded] once and exposes completion, so the
/// app shell can show a brief loading state on first launch instead of
/// racing the UI against an empty database.
final seedImportProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  await SeedImporter(db).importIfNeeded();
});
