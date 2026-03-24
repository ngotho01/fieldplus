import 'package:drift/drift.dart';           // ← fixes Value
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fieldpulse/data/local/database.dart';  // correct package name

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  group('SyncDao', () {
    test('enqueue adds item to queue', () async {
      await db.syncDao.enqueue(
        SyncQueueTableCompanion(
          entityType: const Value('checklist'),
          entityId:   const Value('job-1'),
          action:     const Value('submit'),
          payload:    const Value('{"responses":{}}'),
          createdAt:  Value(DateTime.now()),
        ),
      );
      final items = await db.syncDao.getPendingItems();
      expect(items.length, 1);
      expect(items.first.entityType, 'checklist');
    });

    test('dequeue removes item', () async {
      final id = await db.syncDao.enqueue(
        SyncQueueTableCompanion(
          entityType: const Value('status_update'),
          entityId:   const Value('job-2'),
          action:     const Value('status_update'),
          payload:    const Value('{"status":"completed"}'),
          createdAt:  Value(DateTime.now()),
        ),
      );
      await db.syncDao.dequeue(id);
      final items = await db.syncDao.getPendingItems();
      expect(items, isEmpty);
    });

    test('items with retryCount > 3 excluded from pending', () async {
      // This one should appear in pending (retryCount = 0)
      await db.syncDao.enqueue(
        SyncQueueTableCompanion(
          entityType: const Value('photo'),
          entityId:   const Value('photo-1'),
          action:     const Value('upload'),
          payload:    const Value('{}'),
          createdAt:  Value(DateTime.now()),
        ),
      );

      // Insert directly with retryCount = 4 (exceeded limit)
      await db.into(db.syncQueueTable).insert(
        SyncQueueTableCompanion(
          entityType: const Value('photo'),
          entityId:   const Value('photo-2'),
          action:     const Value('upload'),
          payload:    const Value('{}'),
          retryCount: const Value(4),
          createdAt:  Value(DateTime.now()),
        ),
      );

      final pending = await db.syncDao.getPendingItems();
      expect(pending.any((i) => i.entityId == 'photo-1'), isTrue);
      expect(pending.any((i) => i.entityId == 'photo-2'), isFalse);
    });

    test('incrementRetry updates count', () async {
      final id = await db.syncDao.enqueue(
        SyncQueueTableCompanion(
          entityType: const Value('checklist'),
          entityId:   const Value('job-3'),
          action:     const Value('submit'),
          payload:    const Value('{}'),
          createdAt:  Value(DateTime.now()),
        ),
      );

      await db.syncDao.incrementRetry(id);

      final items = await db.syncDao.getPendingItems();
      expect(items.first.retryCount, 1);
    });
  });

  group('JobsDao', () {
    test('upsertJob inserts then updates on conflict', () async {
      final companion = JobsTableCompanion(
        id:            const Value('job-abc'),
        customerName:  const Value('Alice'),
        customerPhone: const Value('0700'),
        address:       const Value('123 Main'),
        description:   const Value('Fix it'),
        notes:         const Value(''),
        status:        const Value('pending'),
        scheduledStart: Value(DateTime.now()),
        scheduledEnd:   Value(DateTime.now().add(const Duration(hours: 2))),
        serverVersion:  const Value(1),
        isSynced:       const Value(true),
        updatedAt:      Value(DateTime.now()),
      );

      await db.jobsDao.upsertJob(companion);
      await db.jobsDao.upsertJob(
        companion.copyWith(status: const Value('in_progress')),
      );

      final job = await db.jobsDao.getJobById('job-abc');
      expect(job?.status, 'in_progress');
    });
  });
}