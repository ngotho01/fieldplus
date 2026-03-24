import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../local/database.dart';

final checklistRepositoryProvider = Provider<ChecklistRepository>(
      (ref) => ChecklistRepository(
    ref.watch(dioClientProvider),
    ref.watch(appDatabaseProvider),
  ),
);

const _uuid = Uuid();

class ChecklistRepository {
  final Dio _dio;
  final AppDatabase _db;

  ChecklistRepository(this._dio, this._db);

  Future<Map<String, dynamic>?> getDraftResponses(String jobId) async {
    final row = await _db.checklistDao.getResponseForJob(jobId);
    if (row == null) return null;
    return jsonDecode(row.responses) as Map<String, dynamic>;
  }

  Stream<Map<String, dynamic>?> watchDraftResponses(String jobId) =>
      _db.checklistDao.watchResponseForJob(jobId).map(
            (row) => row != null
            ? jsonDecode(row.responses) as Map<String, dynamic>
            : null,
      );

  Future<void> saveDraftLocally(
      String jobId,
      Map<String, dynamic> responses,
      ) async {
    final existing = await _db.checklistDao.getResponseForJob(jobId);
    final id = existing?.id ?? _uuid.v4();
    await _db.checklistDao.upsertResponse(
      ChecklistResponsesTableCompanion(
        id: Value(id),
        jobId: Value(jobId),
        responses: Value(jsonEncode(responses)),
        isDraft: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> submitChecklist(
      String jobId,
      Map<String, dynamic> responses,
      ) async {
    final existing = await _db.checklistDao.getResponseForJob(jobId);
    final id = existing?.id ?? _uuid.v4();

    // Persist locally as submitted (not a draft)
    await _db.checklistDao.upsertResponse(
      ChecklistResponsesTableCompanion(
        id: Value(id),
        jobId: Value(jobId),
        responses: Value(jsonEncode(responses)),
        isDraft: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Enqueue for sync
    await _db.syncDao.enqueue(
      SyncQueueTableCompanion(
        entityType: const Value('checklist'),
        entityId: Value(jobId),
        action: const Value('submit'),
        payload: Value(jsonEncode({'responses': responses})),
        createdAt: Value(DateTime.now()),
      ),
    );

    // Attempt immediate upload if online
    try {
      await _dio.post(
        ApiConstants.checklistSubmit(jobId),
        data: {'responses': responses},
      );
      // Success — remove from queue
      final queue = await _db.syncDao.getPendingItems();
      for (final item in queue) {
        if (item.entityId == jobId && item.entityType == 'checklist') {
          await _db.syncDao.dequeue(item.id);
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final body = e.response?.data as Map<String, dynamic>?;
        final errors = body?['errors'];
        throw ValidationException(
          errors is List
              ? List<String>.from(errors)
              : [errors?.toString() ?? 'Validation failed'],
        );
      }
      // Offline or other error — item stays in queue, that's fine
    }
  }
}