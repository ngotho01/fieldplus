import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../local/database.dart';

final jobsRepositoryProvider = Provider<JobsRepository>(
      (ref) => JobsRepository(
    ref.watch(dioClientProvider),
    ref.watch(appDatabaseProvider),
  ),
);

class JobModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String address;
  final double? latitude;
  final double? longitude;
  final String description;
  final String notes;
  final String status;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final Map<String, dynamic>? checklistSchema;
  final int serverVersion;
  final bool isSynced;
  final bool isOverdue;

  const JobModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    this.latitude,
    this.longitude,
    required this.description,
    required this.notes,
    required this.status,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.checklistSchema,
    required this.serverVersion,
    this.isSynced = true,
    this.isOverdue = false,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    // checklist_schema comes as {"schema": {...}, "version": 1}
    Map<String, dynamic>? schema;
    final raw = json['checklist_schema'];
    if (raw != null && raw is Map<String, dynamic>) {
      schema = raw.containsKey('schema')
          ? raw['schema'] as Map<String, dynamic>?
          : raw;
    }

    return JobModel(
      id:            json['id'] as String,
      customerName:  json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String,
      address:       json['address'] as String,
      // DRF DecimalField serializes as String e.g. "-12.345678"
      // so we must parse with double.tryParse, not cast to num
      latitude:      _parseDouble(json['latitude']),
      longitude:     _parseDouble(json['longitude']),
      description:   json['description'] as String? ?? '',
      notes:         json['notes']       as String? ?? '',
      status:        json['status']      as String,
      scheduledStart: DateTime.parse(json['scheduled_start'] as String),
      scheduledEnd:   DateTime.parse(json['scheduled_end']   as String),
      checklistSchema: schema,
      serverVersion: json['server_version'] as int? ?? 1,
      isOverdue:     json['is_overdue']   as bool? ?? false,
    );
  }

  /// Safely parses latitude/longitude whether the API sends
  /// a String ("12.3456"), an int (0), or a double (12.3456).
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int)    return value.toDouble();
    return double.tryParse(value.toString());
  }

  factory JobModel.fromLocal(JobsTableData row) => JobModel(
    id:            row.id,
    customerName:  row.customerName,
    customerPhone: row.customerPhone,
    address:       row.address,
    latitude:      row.latitude,
    longitude:     row.longitude,
    description:   row.description,
    notes:         row.notes,
    status:        row.status,
    scheduledStart: row.scheduledStart,
    scheduledEnd:   row.scheduledEnd,
    checklistSchema: row.checklistSchema != null
        ? jsonDecode(row.checklistSchema!) as Map<String, dynamic>
        : null,
    serverVersion: row.serverVersion,
    isSynced:      row.isSynced,
    isOverdue:     row.scheduledEnd.isBefore(DateTime.now()) &&
        row.status != 'completed',
  );

  JobsTableCompanion toLocalCompanion() => JobsTableCompanion(
    id:            Value(id),
    customerName:  Value(customerName),
    customerPhone: Value(customerPhone),
    address:       Value(address),
    latitude:      Value(latitude),
    longitude:     Value(longitude),
    description:   Value(description),
    notes:         Value(notes),
    status:        Value(status),
    scheduledStart: Value(scheduledStart),
    scheduledEnd:   Value(scheduledEnd),
    checklistSchema: Value(
      checklistSchema != null ? jsonEncode(checklistSchema) : null,
    ),
    serverVersion: Value(serverVersion),
    isSynced:      const Value(true),
    updatedAt:     Value(DateTime.now()),
  );
}

class JobsRepository {
  final Dio _dio;
  final AppDatabase _db;

  JobsRepository(this._dio, this._db);

  /// Fetches from API and returns results directly.
  /// Caches to local DB in the background (non-blocking).
  Future<List<JobModel>> fetchJobs({
    String? status,
    String? search,
    String? cursor,
  }) async {
    final resp = await _dio.get(
      ApiConstants.jobs,
      queryParameters: {
        if (status != null && status != 'all') 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
        if (cursor != null) 'cursor': cursor,
      },
    );

    final data    = resp.data as Map<String, dynamic>;
    final results = (data['results'] as List)
        .map((j) => JobModel.fromJson(j as Map<String, dynamic>))
        .toList();

    // Cache to DB in background — don't await, don't block UI
    _cacheJobsInBackground(results);

    return results;
  }

  void _cacheJobsInBackground(List<JobModel> jobs) {
    Future(() async {
      try {
        await _db.jobsDao.upsertJobs(
          jobs.map((j) => j.toLocalCompanion()).toList(),
        );
      } catch (e) {
        // Silently ignore cache failures — UI already has data
      }
    });
  }

  /// Reads from local DB only — used when offline.
  Future<List<JobModel>> getLocalJobs({
    String? status,
    String? search,
  }) async {
    List<JobsTableData> rows;
    if (search != null && search.isNotEmpty) {
      rows = await _db.jobsDao.searchJobs(search);
    } else if (status != null && status != 'all') {
      rows = await _db.jobsDao.getJobsByStatus(status);
    } else {
      rows = await _db.jobsDao.getAllJobs();
    }
    return rows.map(JobModel.fromLocal).toList();
  }

  Stream<List<JobModel>> watchLocalJobs() =>
      _db.jobsDao.watchAllJobs().map(
            (rows) => rows.map(JobModel.fromLocal).toList(),
      );

  Future<JobModel?> getJobById(String id) async {

    try {
      final resp = await _dio.get(ApiConstants.jobDetail(id));
      final job  = JobModel.fromJson(resp.data as Map<String, dynamic>);
      _cacheJobsInBackground([job]);
      return job;
    } on DioException catch (e) {
      // Offline — fall back to local DB
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionTimeout) {
        final row = await _db.jobsDao.getJobById(id);
        return row != null ? JobModel.fromLocal(row) : null;
      }
      // Auth error etc — still try local
      final row = await _db.jobsDao.getJobById(id);
      return row != null ? JobModel.fromLocal(row) : null;
    }
  }

  Future<ConflictInfo?> updateJobStatus(
      String id,
      String newStatus,
      int clientVersion,
      ) async {
    // Write locally first (optimistic)
    await _db.jobsDao.updateJobStatus(id, newStatus, clientVersion);

    // Try to sync immediately
    try {
      await _dio.patch(
        ApiConstants.jobStatus(id),
        data: {
          'status':         newStatus,
          'client_version': clientVersion,
        },
      );
      // Success — mark as synced
      await _db.jobsDao.markJobSynced(id, clientVersion + 1);
      return null; // no conflict
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final data = e.response?.data as Map<String, dynamic>;
        // Return conflict info so UI can show dialog
        return ConflictInfo(
          jobId:         id,
          serverVersion: data['server_version'] as int,
          serverStatus:  data['server_status']  as String,
          localStatus:   newStatus,
        );
      }
      // Offline or other error — enqueue for later
      await _db.syncDao.enqueue(
        SyncQueueTableCompanion(
          entityType: const Value('status_update'),
          entityId:   Value(id),
          action:     const Value('status_update'),
          payload:    Value(jsonEncode({
            'status':         newStatus,
            'client_version': clientVersion,
          })),
          createdAt: Value(DateTime.now()),
        ),
      );
      return null;
    }
  }

}
class ConflictInfo {
  final String jobId;
  final int    serverVersion;
  final String serverStatus;
  final String localStatus;

  const ConflictInfo({
    required this.jobId,
    required this.serverVersion,
    required this.serverStatus,
    required this.localStatus,
  });
}