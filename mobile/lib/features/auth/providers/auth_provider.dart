import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../services/auth_service.dart';
import '../../jobs/providers/jobs_provider.dart';

class AuthStateData {
  final bool isLoggedIn;
  final AuthUser? user;

  const AuthStateData({required this.isLoggedIn, this.user});
}

class AuthNotifier extends AsyncNotifier<AuthStateData> {
  @override
  Future<AuthStateData> build() async {
    final repo    = ref.read(authRepositoryProvider);
    final service = ref.read(authServiceProvider);

    final hasSession = await service.hasStoredSession();
    if (!hasSession) return const AuthStateData(isLoggedIn: false);

    final biometricEnabled   = await service.isBiometricEnabled();
    final biometricAvailable = await service.isBiometricAvailable();

    if (biometricEnabled && biometricAvailable) {
      final authenticated = await service.authenticateWithBiometric(
        reason: 'Verify your identity to access FieldPulse',
      );
      if (!authenticated) {
        await repo.logout();
        return const AuthStateData(isLoggedIn: false);
      }
    }

    final user = await repo.getCachedUser();
    return AuthStateData(isLoggedIn: user != null, user: user);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      ref.invalidate(jobsNotifierProvider);
      return AuthStateData(isLoggedIn: true, user: user);
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    ref.invalidate(jobsNotifierProvider);
    state = const AsyncData(AuthStateData(isLoggedIn: false));
  }

  /// Prompts biometric confirmation then saves preference
  Future<bool> enableBiometric() async {
    final service = ref.read(authServiceProvider);
    final available = await service.isBiometricAvailable();
    if (!available) return false;

    final confirmed = await service.authenticateWithBiometric(
      reason: 'Confirm biometric to enable quick unlock',
    );
    if (confirmed) {
      await service.setBiometricEnabled(true);
    }
    return confirmed;
  }

  Future<void> disableBiometric() async {
    await ref.read(authServiceProvider).setBiometricEnabled(false);
  }
}

final authNotifierProvider =
AsyncNotifierProvider<AuthNotifier, AuthStateData>(AuthNotifier.new);

// ── Convenience providers for UI ──────────────────────────────────────────────

final biometricEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(authServiceProvider).isBiometricEnabled();
});

final biometricAvailableProvider = FutureProvider<bool>((ref) {
  return ref.watch(authServiceProvider).isBiometricAvailable();
});

final availableBiometricsProvider = FutureProvider<List<BiometricType>>((ref) {
  return ref.watch(authServiceProvider).getAvailableBiometrics();
});