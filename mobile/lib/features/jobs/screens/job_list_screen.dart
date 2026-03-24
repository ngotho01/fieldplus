import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/repositories/jobs_repository.dart';
import '../../../services/location_service.dart';
import '../../../services/sync_service.dart';
import '../providers/jobs_provider.dart';
import '../widgets/job_card.dart';
import '../../sync/widgets/sync_status_bar.dart';

class JobListScreen extends ConsumerStatefulWidget {
  const JobListScreen({super.key});

  @override
  ConsumerState<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends ConsumerState<JobListScreen> {
  final _searchCtrl = TextEditingController();
  Map<String, double>? _distances;
  static const _statusTabs = ['all', 'pending', 'in_progress', 'completed'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jobsNotifierProvider.notifier).refresh();
      _loadDistances();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDistances() async {
    final pos = await ref.read(locationServiceProvider).getCurrentPosition();
    if (pos == null || !mounted) return;
    final jobs = ref.read(jobsNotifierProvider).valueOrNull ?? [];
    final Map<String, double> d = {};
    for (final j in jobs) {
      final dist = ref.read(locationServiceProvider).distanceBetween(
        j.latitude, j.longitude, pos.latitude, pos.longitude,
      );
      if (dist != null) d[j.id] = dist;
    }
    if (mounted) setState(() => _distances = d);
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(jobFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_outlined),
            tooltip: 'Sync now',
            onPressed: () => ref.read(syncServiceProvider.notifier).syncAll(),
          ),
        ],
      ),
      body: Column(
        children: [
          const SyncStatusBar(),
          _buildSearchBar(filters),
          _buildStatusTabs(filters),
          Expanded(child: _buildJobList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar(JobFilters filters) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _searchCtrl,
        decoration: InputDecoration(
          hintText: 'Search by name, address…',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: filters.search != null
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchCtrl.clear();
              ref.read(jobFiltersProvider.notifier).update(
                    (s) => s.copyWith(search: ''),
              );
              ref.read(jobsNotifierProvider.notifier).refresh();
            },
          )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onSubmitted: (v) {
          ref.read(jobFiltersProvider.notifier).update(
                (s) => s.copyWith(search: v.isEmpty ? null : v),
          );
          ref.read(jobsNotifierProvider.notifier).refresh();
        },
      ),
    );
  }

  Widget _buildStatusTabs(JobFilters filters) {
    final labels = {
      'all': 'All', 'pending': 'Pending',
      'in_progress': 'In Progress', 'completed': 'Completed',
    };
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _statusTabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final tab = _statusTabs[i];
          final selected = (filters.status ?? 'all') == tab;
          return ChoiceChip(
            label: Text(labels[tab]!),
            selected: selected,
            onSelected: (_) {
              ref.read(jobFiltersProvider.notifier).update(
                    (s) => s.copyWith(
                  status: tab == 'all' ? null : tab,
                  clearStatus: tab == 'all',
                ),
              );
              ref.read(jobsNotifierProvider.notifier).refresh();
            },
          );
        },
      ),
    );
  }

  Widget _buildJobList() {
    final jobsAsync = ref.watch(jobsNotifierProvider);

    return jobsAsync.when(
      loading: () => _buildShimmer(),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(e.toString()),
            TextButton(
              onPressed: () => ref.read(jobsNotifierProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (jobs) {
        if (jobs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.work_off_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('No jobs found'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(jobsNotifierProvider.notifier).refresh(),
          child: ListView.builder(
            itemCount: jobs.length,
            // RepaintBoundary per card → 60fps scroll with 500+ items
            itemBuilder: (_, i) => RepaintBoundary(
              child: JobCard(
                job: jobs[i],
                distanceKm: _distances?[jobs[i].id],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => const Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: SizedBox(height: 90),
        ),
      ),
    );
  }
}