part of '../database.dart';

@DriftAccessor(tables: [ChecklistResponsesTable])
class ChecklistDao extends DatabaseAccessor<AppDatabase>
    with _$ChecklistDaoMixin {
  ChecklistDao(super.db);

  Future<ChecklistResponsesTableData?> getResponseForJob(String jobId) =>
      (select(checklistResponsesTable)
        ..where((t) => t.jobId.equals(jobId)))
          .getSingleOrNull();

  Stream<ChecklistResponsesTableData?> watchResponseForJob(String jobId) =>
      (select(checklistResponsesTable)
        ..where((t) => t.jobId.equals(jobId)))
          .watchSingleOrNull();

  Future<void> upsertResponse(ChecklistResponsesTableCompanion response) =>
      into(checklistResponsesTable).insertOnConflictUpdate(response);

  Future<List<ChecklistResponsesTableData>> getDraftResponses() =>
      (select(checklistResponsesTable)
        ..where((t) => t.isDraft.equals(true)))
          .get();

  Future<void> deleteResponse(String id) =>
      (delete(checklistResponsesTable)
        ..where((t) => t.id.equals(id)))
          .go();
}