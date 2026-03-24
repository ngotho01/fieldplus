import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../services/sync_service.dart';
import '../../../data/repositories/sync_repository.dart';

// ── Re-export the core sync state so UI only imports this file ────────────────
export '../../../services/sync_service.dart' show SyncStatus, SyncState;

// ── Connectivity stream ───────────────────────────────────────────────────────

/// Emits every time connectivity changes. When it becomes non-none,
/// triggers an automatic sync.
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Watches connectivity and auto-triggers sync when coming back online.
final autoSyncProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<List<ConnectivityResult>>>(
    connectivityProvider,
        (previous, next) {
      final wasOffline = previous?.valueOrNull
          ?.every((r) => r == ConnectivityResult.none) ??
          true;
      final isOnline = next.valueOrNull
          ?.any((r) => r != ConnectivityResult.none) ??
          false;

      if (wasOffline && isOnline) {
        // Came back online — flush the queue
        ref.read(syncServiceProvider.notifier).syncAll();
      }
    },
  );
});

// ── Pending count badge (for AppBar / BottomNav badges) ──────────────────────

final pendingCountBadgeProvider = Provider<String?>((ref) {
  final count = ref.watch(pendingCountProvider);
  if (count == 0) return null;
  return count > 99 ? '99+' : '$count';
});

// ── Sync status label (human-readable, for status bar) ───────────────────────

final syncStatusLabelProvider = Provider<String>((ref) {
  final syncAsync = ref.watch(syncServiceProvider);
  final pending   = ref.watch(pendingCountProvider);

  return syncAsync.when(
    loading: () => 'Syncing…',
    error: (_, __) => 'Sync failed',
    data: (state) => switch (state.status) {
      SyncStatus.syncing => 'Syncing…',
      SyncStatus.offline => pending > 0
          ? '$pending pending — offline'
          : 'Offline',
      SyncStatus.error   => state.errorMessage ?? 'Sync error',
      SyncStatus.done    => 'All synced',
      SyncStatus.idle    => pending > 0 ? '$pending pending' : 'Up to date',
    },
  );
});

// ── Manual sync trigger (callable from any widget) ───────────────────────────

/// Call `ref.read(syncTriggerProvider)()` from any widget to kick off sync.
final syncTriggerProvider = Provider<Future<void> Function()>((ref) {
  return () => ref.read(syncServiceProvider.notifier).syncAll();
});