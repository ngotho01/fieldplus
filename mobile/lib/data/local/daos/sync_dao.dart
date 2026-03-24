part of '../database.dart';

@DriftAccessor(tables: [SyncQueueTable])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.db);

  Stream<List<SyncQueueTableData>> watchQueue() =>
      (select(syncQueueTable)
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<List<SyncQueueTableData>> getPendingItems() =>
      (select(syncQueueTable)
        ..where((t) => t.retryCount.isSmallerOrEqualValue(3))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<int> enqueue(SyncQueueTableCompanion item) =>
      into(syncQueueTable).insert(item);

  Future<void> incrementRetry(int id) async {
    // Fetch current count, then write count + 1
    final item = await (select(syncQueueTable)
      ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (item == null) return;
    await (update(syncQueueTable)..where((t) => t.id.equals(id))).write(
      SyncQueueTableCompanion(retryCount: Value(item.retryCount + 1)),
    );
  }

  Future<void> dequeue(int id) =>
      (delete(syncQueueTable)..where((t) => t.id.equals(id))).go();

  Future<int> getQueueCount() =>
      (selectOnly(syncQueueTable)
        ..addColumns([syncQueueTable.id.count()]))
          .map((r) => r.read(syncQueueTable.id.count()) ?? 0)
          .getSingle();

  Future<void> clearQueue() => delete(syncQueueTable).go();
}