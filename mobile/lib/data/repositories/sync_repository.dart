import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';           // ← fixes Value + Companion
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../local/database.dart';

final syncRepositoryProvider = Provider<SyncRepository>(
      (ref) => SyncRepository(
    ref.watch(dioClientProvider),
    ref.watch(appDatabaseProvider),
  ),
);

class SyncRepository {
  final Dio _dio;
  final AppDatabase _db;

  SyncRepository(this._dio, this._db);

  Stream<int> watchPendingCount() =>
      _db.syncDao.watchQueue().map((q) => q.length);

  Future<List<SyncQueueTableData>> getPendingItems() =>
      _db.syncDao.getPendingItems();

  Future<void> processItem(SyncQueueTableData item) async {
    switch (item.entityType) {
      case 'checklist':
        final payload = jsonDecode(item.payload) as Map<String, dynamic>;
        await _dio.post(
          ApiConstants.checklistSubmit(item.entityId),
          data: payload,
        );

      case 'status_update':
        final payload = jsonDecode(item.payload) as Map<String, dynamic>;
        await _dio.patch(
          ApiConstants.jobStatus(item.entityId),
          data: payload,
        );

      case 'photo':
      case 'signature':
      // Handled by ApiService.uploadPhoto / uploadSignature
        break;
    }
    await _db.syncDao.dequeue(item.id);
  }

  Future<void> incrementRetry(int id) =>
      _db.syncDao.incrementRetry(id);

  Future<void> resolveConflict({
    required String jobId,
    required String resolution,
    Map<String, dynamic>? mergedResponses,
  }) async {
    await _dio.post(
      ApiConstants.syncConflictResolve,
      data: {
        'job_id': jobId,
        'resolution': resolution,
        if (mergedResponses != null) 'merged_responses': mergedResponses,
      },
    );
  }
}