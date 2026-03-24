import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../core/errors/exceptions.dart';
import '../core/network/dio_client.dart';

final apiServiceProvider = Provider<ApiService>(
      (ref) => ApiService(ref.watch(dioClientProvider)),
);

class ApiService {
  final Dio _dio;
  ApiService(this._dio);

  // ── Auth ───────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> login(String email, String password) =>
      _post(ApiConstants.login, {'email': email, 'password': password});

  Future<Map<String, dynamic>> refreshToken(String refresh) =>
      _post(ApiConstants.refresh, {'refresh': refresh});

  Future<void> logout(String refresh) async =>
      _post(ApiConstants.logout, {'refresh': refresh});

  Future<Map<String, dynamic>> getProfile() => _get(ApiConstants.profile);

  Future<void> registerFcmToken(String token) async =>
      _post(ApiConstants.fcmRegister, {'token': token});

  // ── Jobs ──────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getJobs({
    String? status,
    String? search,
    String? cursor,
    int pageSize = 20,
  }) =>
      _get(ApiConstants.jobs, queryParams: {
        if (status != null) 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
        if (cursor != null) 'cursor': cursor,
        'page_size': pageSize,
      });

  Future<Map<String, dynamic>> getJobDetail(String jobId) =>
      _get(ApiConstants.jobDetail(jobId));

  Future<Map<String, dynamic>> getJobSchema(String jobId) =>
      _get(ApiConstants.jobSchema(jobId));

  /// [payload] is a JSON string containing `status` and `client_version`.
  Future<Map<String, dynamic>> updateJobStatus(
      String jobId,
      String payload,
      ) {
    final data = jsonDecode(payload) as Map<String, dynamic>;
    return _patch(ApiConstants.jobStatus(jobId), data);
  }

  // ── Checklist ─────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> saveDraft(
      String jobId,
      Map<String, dynamic> responses,
      ) =>
      _post(ApiConstants.checklistDraft(jobId), {'responses': responses});

  /// [payload] is a JSON string. Can be `{"responses": {...}}` from queue
  /// or a raw responses map encoded as JSON.
  Future<Map<String, dynamic>> submitChecklist(
      String jobId,
      String payload,
      ) {
    final decoded = jsonDecode(payload) as Map<String, dynamic>;
    // Normalise: wrap bare responses map if needed
    final data = decoded.containsKey('responses')
        ? decoded
        : {'responses': decoded};
    return _post(ApiConstants.checklistSubmit(jobId), data);
  }

  Future<Map<String, dynamic>> getChecklistResponse(String jobId) =>
      _get(ApiConstants.checklistGet(jobId));

  // ── Media ─────────────────────────────────────────────────────────────────

  /// [payload] JSON string: `{local_path, field_id, captured_at, latitude?, longitude?}`
  Future<Map<String, dynamic>> uploadPhoto(
      String jobId,
      String payload,
      ) async {
    final p          = jsonDecode(payload) as Map<String, dynamic>;
    final localPath  = p['local_path']  as String;
    final fieldId    = p['field_id']    as String;
    final capturedAt = p['captured_at'] as String;
    final lat        = p['latitude']?.toString();
    final lon        = p['longitude']?.toString();

    final formData = FormData.fromMap({
      'job':         jobId,
      'field_id':    fieldId,
      'captured_at': capturedAt,
      if (lat != null) 'latitude':  lat,
      if (lon != null) 'longitude': lon,
      'file': await MultipartFile.fromFile(
        localPath,
        filename: localPath.split('/').last,
      ),
    });
    return _postForm(ApiConstants.photoUpload, formData);
  }

  /// [payload] JSON string: `{local_path, field_id, captured_at}`
  Future<Map<String, dynamic>> uploadSignature(
      String jobId,
      String payload,
      ) async {
    final p          = jsonDecode(payload) as Map<String, dynamic>;
    final localPath  = p['local_path']  as String;
    final fieldId    = p['field_id']    as String;
    final capturedAt = p['captured_at'] as String;

    final formData = FormData.fromMap({
      'job':         jobId,
      'field_id':    fieldId,
      'captured_at': capturedAt,
      'file': await MultipartFile.fromFile(
        localPath,
        filename: localPath.split('/').last,
        contentType: DioMediaType('image', 'png'),
      ),
    });
    return _postForm(ApiConstants.signatureUpload, formData);
  }

  Future<Map<String, dynamic>> getPhoto(String photoId) =>
      _get(ApiConstants.photoDetail(photoId));

  // ── Sync ──────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> bulkSync(
      List<Map<String, dynamic>> jobs,
      ) =>
      _post(ApiConstants.syncBulk, {'jobs': jobs});

  Future<Map<String, dynamic>> resolveConflict({
    required String jobId,
    required String resolution,
    Map<String, dynamic>? mergedResponses,
  }) =>
      _post(ApiConstants.syncConflictResolve, {
        'job_id':     jobId,
        'resolution': resolution,
        if (mergedResponses != null) 'merged_responses': mergedResponses,
      });

  // ── Private HTTP helpers ──────────────────────────────────────────────────

  Future<Map<String, dynamic>> _get(
      String path, {
        Map<String, dynamic>? queryParams,
      }) async {
    try {
      final resp = await _dio.get(path, queryParameters: queryParams);
      return resp.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> _post(
      String path,
      Map<String, dynamic> data,
      ) async {
    try {
      final resp = await _dio.post(path, data: data);
      return resp.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> _patch(
      String path,
      Map<String, dynamic> data,
      ) async {
    try {
      final resp = await _dio.patch(path, data: data);
      return resp.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Map<String, dynamic>> _postForm(
      String path,
      FormData formData,
      ) async {
    try {
      final resp = await _dio.post(
        path,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return resp.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  AppException _mapDioError(DioException e) {
    final status  = e.response?.statusCode;
    final message = _extractMessage(e);

    return switch (status) {
      400                       => ServerException(message, statusCode: status),
      401                       => const AuthException('Session expired. Please log in again.'),
      403                       => const AuthException('Access denied.'),
      404                       => ServerException('Not found.', statusCode: status),
      409                       => ServerException(message, statusCode: status),
      422                       => ValidationException([message]),
      429                       => const ServerException('Too many requests. Slow down.'),
      500 || 502 || 503         => const ServerException('Server error. Try again shortly.'),
      _ when e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown
      => const OfflineException(),
      _ when e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout
      => const NetworkException('Request timed out.'),
      _                         => NetworkException(e.message ?? 'Unknown network error.'),
    };
  }

  String _extractMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map) {
        return (data['errors'] ?? data['detail'] ?? data['message'])
            ?.toString() ??
            e.message ??
            'Unknown error';
      }
    } catch (_) {}
    return e.message ?? 'Unknown error';
  }
}