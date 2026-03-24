import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';

final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepository(ref.watch(dioClientProvider)),
);

class AuthUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatarUrl;

  const AuthUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.avatarUrl,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'].toString(),
    email: json['email'] as String,
    firstName: json['first_name'] as String? ?? '',
    lastName: json['last_name'] as String? ?? '',
    phone: json['phone'] as String?,
    avatarUrl: json['avatar_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'email': email,
    'first_name': firstName, 'last_name': lastName,
    'phone': phone, 'avatar_url': avatarUrl,
  };
}

class AuthRepository {
  final Dio _dio;
  static const _storage = FlutterSecureStorage();

  AuthRepository(this._dio);

  Future<AuthUser> login(String email, String password) async {
    try {
      final resp = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final data = resp.data as Map<String, dynamic>;
      await _storage.write(key: AppConstants.accessTokenKey,  value: data['access']  as String);
      await _storage.write(key: AppConstants.refreshTokenKey, value: data['refresh'] as String);
      final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
      await _storage.write(key: AppConstants.userKey, value: jsonEncode(user.toJson()));
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw const AuthException('Invalid email or password.');
      }
      throw NetworkException(e.message ?? 'Network error');
    }
  }

  Future<void> logout() async {
    try {
      final refresh = await _storage.read(key: AppConstants.refreshTokenKey);
      if (refresh != null) {
        await _dio.post(ApiConstants.logout, data: {'refresh': refresh});
      }
    } catch (_) {
      // Best-effort logout
    } finally {
      await _storage.deleteAll();
    }
  }

  Future<AuthUser?> getCachedUser() async {
    final raw = await _storage.read(key: AppConstants.userKey);
    if (raw == null) return null;
    return AuthUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<bool> hasValidSession() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null;
  }

  Future<AuthUser> getProfile() async {
    try {
      final resp = await _dio.get(ApiConstants.profile);
      final user = AuthUser.fromJson(
          (resp.data as Map<String, dynamic>)['user'] as Map<String, dynamic>);
      await _storage.write(key: AppConstants.userKey, value: jsonEncode(user.toJson()));
      return user;
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'Failed to load profile');
    }
  }
}