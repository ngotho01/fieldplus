import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/jobs_dao.dart';

// ── Table definitions ──────────────────────────────────────────────────────
part 'tables/jobs_table.dart';
part 'tables/checklist_table.dart';
part 'tables/sync_queue_table.dart';
part 'tables/photos_table.dart';

// ── DAO definitions ────────────────────────────────────────────────────────

part 'daos/checklist_dao.dart';
part 'daos/sync_dao.dart';

// ── Generated code ─────────────────────────────────────────────────────────
part 'database.g.dart';

@DriftDatabase(
  tables: [JobsTable, ChecklistResponsesTable, SyncQueueTable, PhotosTable],
  daos: [JobsDao, ChecklistDao, SyncDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// In-memory constructor for unit tests
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'fieldpulse.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});