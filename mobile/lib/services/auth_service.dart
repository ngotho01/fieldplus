import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/app_constants.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final _auth = LocalAuthentication();
  static const _storage = FlutterSecureStorage();

  // ── Device capability ─────────────────────────────────────────────────────

  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck  = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      return canCheck && supported;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  // ── User preference ───────────────────────────────────────────────────────

  Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: AppConstants.biometricEnabledKey);
    return val == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: AppConstants.biometricEnabledKey,
      value: enabled.toString(),
    );
  }

  // ── Authentication ────────────────────────────────────────────────────────

  Future<bool> authenticateWithBiometric({
    String reason = 'Unlock FieldPulse',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth:      true,
          biometricOnly:   false,
          useErrorDialogs: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  // ── Session helpers ───────────────────────────────────────────────────────

  Future<bool> hasStoredSession() async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    return token != null;
  }

  Future<void> clearSession() => _storage.deleteAll();
}