import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../data/repositories/jobs_repository.dart';

// ── Filters ───────────────────────────────────────────────────────────────────

class JobFilters {
  final String? status;
  final String? search;

  const JobFilters({this.status, this.search});

  JobFilters copyWith({
    String? status,
    String? search,
    bool clearStatus = false,
  }) =>
      JobFilters(
        status: clearStatus ? null : (status ?? this.status),
        search: search ?? this.search,
      );
}

final jobFiltersProvider =
StateProvider<JobFilters>((_) => const JobFilters());

// ── Notifier ──────────────────────────────────────────────────────────────────

class JobsNotifier extends AsyncNotifier<List<JobModel>> {
  @override
  Future<List<JobModel>> build() async {
    final filters = ref.watch(jobFiltersProvider);
    final repo    = ref.read(jobsRepositoryProvider);

    try {
      // Online — fetch from API directly (returns results + caches to DB)
      return await repo.fetchJobs(
        status: filters.status,
        search: filters.search,
      );
    } on AuthException {
      // 401 at app start before token is ready — return empty silently.
      // Will be invalidated and rebuilt after login.
      return [];
    } on OfflineException {
      // Offline — fall back to local SQLite
      return repo.getLocalJobs(
        status: filters.status,
        search: filters.search,
      );
    } catch (e) {
      // Any other error — try local DB before surfacing the error
      final local = await repo.getLocalJobs(
        status: filters.status,
        search: filters.search,
      );
      if (local.isNotEmpty) return local;
      rethrow;
    }
  }

  // ── Pull-to-refresh ────────────────────────────────────────────────────────

  Future<void> refresh() async {
    state = const AsyncLoading();
    final filters = ref.read(jobFiltersProvider);
    final repo    = ref.read(jobsRepositoryProvider);

    state = await AsyncValue.guard(() async {
      try {
        return await repo.fetchJobs(
          status: filters.status,
          search: filters.search,
        );
      } on OfflineException {
        return repo.getLocalJobs(
          status: filters.status,
          search: filters.search,
        );
      }
    });
  }

  // ── Status update — returns ConflictInfo if 409, null otherwise ────────────

  Future<ConflictInfo?> updateStatus(
      String jobId,
      String newStatus,
      int clientVersion,
      ) async {
    final conflict = await ref
        .read(jobsRepositoryProvider)
        .updateJobStatus(jobId, newStatus, clientVersion);

    // Rebuild the list to reflect the optimistic local change
    ref.invalidateSelf();

    return conflict;
  }
}

final jobsNotifierProvider =
AsyncNotifierProvider<JobsNotifier, List<JobModel>>(JobsNotifier.new);

// ── Job detail ────────────────────────────────────────────────────────────────

final jobDetailProvider =
FutureProvider.family<JobModel?, String>((ref, jobId) {
  return ref.watch(jobsRepositoryProvider).getJobById(jobId);
});