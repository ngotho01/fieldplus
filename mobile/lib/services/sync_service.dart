import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../data/repositories/sync_repository.dart';
import '../data/local/database.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum SyncStatus { idle, syncing, done, offline, error }

class SyncState {
  final SyncStatus status;
  final int pendingCount;
  final String? errorMessage;

  const SyncState({
    this.status = SyncStatus.idle,
    this.pendingCount = 0,
    this.errorMessage,
  });

  SyncState copyWith({
    SyncStatus? status,
    int? pendingCount,
    String? errorMessage,
  }) =>
      SyncState(
        status:       status       ?? this.status,
        pendingCount: pendingCount ?? this.pendingCount,
        errorMessage: errorMessage,
      );
}

// ── Internal stream provider (private) ───────────────────────────────────────

final _pendingCountStreamProvider = StreamProvider<int>((ref) {
  return ref.watch(syncRepositoryProvider).watchPendingCount();
});

// ── Public count provider ─────────────────────────────────────────────────────

final pendingCountProvider = Provider<int>((ref) {
  // .valueOrNull unwraps AsyncValue<int> → int?
  return ref.watch(_pendingCountStreamProvider).valueOrNull ?? 0;
});

// ── Notifier ──────────────────────────────────────────────────────────────────

final syncServiceProvider =
AsyncNotifierProvider<SyncNotifier, SyncState>(SyncNotifier.new);

class SyncNotifier extends AsyncNotifier<SyncState> {
  @override
  Future<SyncState> build() async {
    // Watch the stream and update pendingCount whenever it changes.
    // The callback receives AsyncValue<int> — unwrap with .valueOrNull.
    ref.listen<AsyncValue<int>>(
      _pendingCountStreamProvider,
          (_, next) {
        final count = next.valueOrNull ?? 0;          // ← the fix
        if (state.hasValue) {
          state = AsyncData(state.value!.copyWith(pendingCount: count));
        }
      },
    );

    final initialCount =
    await ref.read(syncRepositoryProvider).getPendingItems().then(
          (l) => l.length,
    );
    return SyncState(pendingCount: initialCount);
  }

  Future<void> syncAll() async {
    final current      = state.valueOrNull ?? const SyncState();
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity.contains(ConnectivityResult.none) ||
        connectivity.isEmpty) {
      state = AsyncData(current.copyWith(status: SyncStatus.offline));
      return;
    }

    state = AsyncData(current.copyWith(status: SyncStatus.syncing));
    final repo = ref.read(syncRepositoryProvider);

    try {
      final queue = await repo.getPendingItems();

      for (final item in queue) {
        if (item.retryCount >= AppConstants.maxSyncRetries) continue;
        try {
          await repo.processItem(item);
        } catch (_) {
          await repo.incrementRetry(item.id);
        }
      }

      state = AsyncData(
        (state.valueOrNull ?? const SyncState())
            .copyWith(status: SyncStatus.done),
      );
    } catch (e) {
      state = AsyncData(
        (state.valueOrNull ?? const SyncState()).copyWith(
          status:       SyncStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}