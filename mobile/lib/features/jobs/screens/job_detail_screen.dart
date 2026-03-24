import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/repositories/jobs_repository.dart';
import '../../../data/repositories/sync_repository.dart';
import '../providers/job_detail_provider.dart';
import '../providers/jobs_provider.dart' hide jobDetailProvider;
import '../widgets/status_badge.dart';

class JobDetailScreen extends ConsumerWidget {
  final String jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(jobDetailProvider(jobId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          jobAsync.whenOrNull(
            data: (job) => job != null
                ? IconButton(
              icon: const Icon(Icons.navigation_outlined),
              tooltip: 'Navigate',
              onPressed: () => _openMaps(job),
            )
                : null,
          ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: jobAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(error: e.toString(), jobId: jobId),
        data: (job) {
          if (job == null) {
            return const Center(child: Text('Job not found'));
          }
          return _JobDetailBody(
            job: job,
            onStatusUpdate: (newStatus) async {
              final conflict = await ref
                  .read(jobsNotifierProvider.notifier)
                  .updateStatus(jobId, newStatus, job.serverVersion);

              if (!context.mounted) return;

              if (conflict != null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => ConflictDialog(
                    conflict: conflict,
                    onAcceptServer: () {
                      // Discard local change — reload from server
                      ref.invalidate(jobDetailProvider(jobId));
                      ref.invalidate(jobsNotifierProvider);
                    },
                    onKeepLocal: () async {
                      // Resolve on server so our version wins
                      await ref
                          .read(syncRepositoryProvider)
                          .resolveConflict(
                        jobId: jobId,
                        resolution: 'keep_local',
                      );
                      ref.invalidate(jobDetailProvider(jobId));
                      ref.invalidate(jobsNotifierProvider);
                    },
                  ),
                );
              } else {
                ref.invalidate(jobDetailProvider(jobId));
              }
            },
          );
        },
      ),
    );
  }

  void _openMaps(JobModel job) {
    if (job.latitude != null && job.longitude != null) {
      launchUrl(Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
            '&destination=${job.latitude},${job.longitude}',
      ));
    } else {
      launchUrl(Uri.parse(
        'https://www.google.com/maps/search/'
            '?q=${Uri.encodeComponent(job.address)}',
      ));
    }
  }
}

// ── Error body ────────────────────────────────────────────────────────────────

class _ErrorBody extends ConsumerWidget {
  final String error;
  final String jobId;
  const _ErrorBody({required this.error, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined,
                size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(jobDetailProvider(jobId)),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Main body ─────────────────────────────────────────────────────────────────

class _JobDetailBody extends StatelessWidget {
  final JobModel job;
  final void Function(String) onStatusUpdate;

  const _JobDetailBody({
    required this.job,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Customer ──────────────────────────────────────────────────
          _SectionCard(
            title: 'Customer',
            children: [
              _InfoRow(
                icon: Icons.person_outlined,
                label: 'Name',
                value: job.customerName,
              ),
              _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: job.customerPhone,
                onTap: () =>
                    launchUrl(Uri.parse('tel:${job.customerPhone}')),
              ),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: job.address,
                onTap: () => launchUrl(Uri.parse(
                  'https://www.google.com/maps/search/'
                      '?q=${Uri.encodeComponent(job.address)}',
                )),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Schedule ──────────────────────────────────────────────────
          _SectionCard(
            title: 'Schedule',
            children: [
              _InfoRow(
                icon: Icons.schedule_outlined,
                label: 'Window',
                value: AppDateUtils.scheduleWindow(
                  job.scheduledStart,
                  job.scheduledEnd,
                ),
              ),
              _InfoRow(
                icon: Icons.info_outline,
                label: 'Status',
                value: job.isOverdue && job.status != 'completed'
                    ? 'Overdue'
                    : job.status.replaceAll('_', ' ').toUpperCase(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Details ───────────────────────────────────────────────────
          _SectionCard(
            title: 'Details',
            children: [
              _InfoRow(
                icon: Icons.description_outlined,
                label: 'Description',
                value: job.description,
              ),
              if (job.notes.isNotEmpty)
                _InfoRow(
                  icon: Icons.notes_outlined,
                  label: 'Notes',
                  value: job.notes,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Status controls ───────────────────────────────────────────
          _StatusSection(job: job, onUpdate: onStatusUpdate),
          const SizedBox(height: 16),

          // ── Checklist CTA ─────────────────────────────────────────────
          if (job.checklistSchema != null)
            FilledButton.icon(
              icon: const Icon(Icons.checklist_outlined),
              label: Text(
                job.status == 'completed'
                    ? 'View Checklist'
                    : 'Open Checklist',
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () =>
                  context.push('/jobs/${job.id}/checklist'),
            )
          else
            OutlinedButton.icon(
              icon: const Icon(Icons.checklist_outlined),
              label: const Text('No checklist for this job'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: null,
            ),

          const SizedBox(height: 8),

          // ── Sync status ───────────────────────────────────────────────
          if (!job.isSynced)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Changes saved locally — will sync when online.',
                      style: TextStyle(
                          color: Colors.orange, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Status section ────────────────────────────────────────────────────────────

class _StatusSection extends StatelessWidget {
  final JobModel job;
  final void Function(String) onUpdate;

  const _StatusSection({required this.job, required this.onUpdate});

  static const _transitions = {
    'pending':     ['in_progress'],
    'in_progress': ['pending', 'completed'],
    'completed':   <String>[],
  };

  @override
  Widget build(BuildContext context) {
    final transitions = _transitions[job.status] ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Status',
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                StatusBadge(
                    status: job.status, isOverdue: job.isOverdue),
              ],
            ),
            if (transitions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: transitions.map((s) {
                  return OutlinedButton(
                    onPressed: () => _confirm(context, s),
                    child: Text(_label(s)),
                  );
                }).toList(),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                'Job is completed — no further status changes.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _label(String s) => switch (s) {
    'pending'     => 'Reset to Pending',
    'in_progress' => 'Start Job',
    'completed'   => 'Mark Complete',
    _             => s,
  };

  void _confirm(BuildContext context, String newStatus) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Status'),
        content: Text('Change status to "${_label(newStatus)}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) onUpdate(newStatus);
    });
  }
}

// ── Conflict resolution dialog ────────────────────────────────────────────────

class ConflictDialog extends StatelessWidget {
  final ConflictInfo conflict;
  final VoidCallback onKeepLocal;
  final VoidCallback onAcceptServer;

  const ConflictDialog({
    super.key,
    required this.conflict,
    required this.onKeepLocal,
    required this.onAcceptServer,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: cs.error, size: 22),
          const SizedBox(width: 8),
          const Text('Sync Conflict'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This job was updated on the server while you were offline.',
          ),
          const SizedBox(height: 16),
          _ConflictRow(
            label: 'Server status',
            value: conflict.serverStatus,
            color: cs.primary,
          ),
          const SizedBox(height: 6),
          _ConflictRow(
            label: 'Your change',
            value: conflict.localStatus,
            color: cs.tertiary,
          ),
          const SizedBox(height: 12),
          Text(
            'Which version would you like to keep?',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onAcceptServer();
          },
          child: const Text('Use Server'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onKeepLocal();
          },
          child: const Text('Keep Mine'),
        ),
      ],
    );
  }
}

class _ConflictRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ConflictRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label: ',
            style: Theme.of(context).textTheme.bodySmall),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.replaceAll('_', ' ').toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleSmall),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: cs.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  Text(
                    value,
                    style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: onTap != null ? cs.primary : null,
                      decoration: onTap != null
                          ? TextDecoration.underline
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right,
                  size: 18, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}