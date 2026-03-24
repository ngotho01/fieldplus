import 'package:drift/drift.dart';
import '../database.dart';

part 'jobs_dao.g.dart';

@DriftAccessor(tables: [JobsTable])
class JobsDao extends DatabaseAccessor<AppDatabase> with _$JobsDaoMixin {
  JobsDao(super.db);

  Future<List<JobsTableData>> getAllJobs() =>
      (select(jobsTable)..orderBy([(t) => OrderingTerm.asc(t.scheduledStart)])).get();

  Stream<List<JobsTableData>> watchAllJobs() =>
      (select(jobsTable)..orderBy([(t) => OrderingTerm.asc(t.scheduledStart)])).watch();

  Future<List<JobsTableData>> getJobsByStatus(String status) =>
      (select(jobsTable)..where((t) => t.status.equals(status))).get();

  Future<List<JobsTableData>> searchJobs(String query) =>
      (select(jobsTable)
        ..where((t) =>
        t.customerName.like('%$query%') |
        t.address.like('%$query%') |
        t.description.like('%$query%')))
          .get();

  Future<JobsTableData?> getJobById(String id) =>
      (select(jobsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertJob(JobsTableCompanion job) =>
      into(jobsTable).insertOnConflictUpdate(job);

  Future<void> upsertJobs(List<JobsTableCompanion> jobs) =>
      batch((b) => b.insertAllOnConflictUpdate(jobsTable, jobs));

  Future<void> updateJobStatus(String id, String status, int newVersion) =>
      (update(jobsTable)..where((t) => t.id.equals(id))).write(
        JobsTableCompanion(
          status: Value(status),
          serverVersion: Value(newVersion),
          isSynced: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<List<JobsTableData>> getUnsyncedJobs() =>
      (select(jobsTable)..where((t) => t.isSynced.equals(false))).get();

  Future<void> markJobSynced(String id, int serverVersion) =>
      (update(jobsTable)..where((t) => t.id.equals(id))).write(
        JobsTableCompanion(
          isSynced: const Value(true),
          serverVersion: Value(serverVersion),
        ),
      );

  Future<void> deleteJob(String id) =>
      (delete(jobsTable)..where((t) => t.id.equals(id))).go();
}