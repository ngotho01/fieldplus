import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/repositories/jobs_repository.dart';
import 'status_badge.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final double? distanceKm;

  const JobCard({super.key, required this.job, this.distanceKm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/jobs/${job.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: customer name + badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.customerName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(status: job.status, isOverdue: job.isOverdue),
                ],
              ),
              const SizedBox(height: 6),

              // Address
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      job.address,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (distanceKm != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${distanceKm!.toStringAsFixed(1)} km',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Schedule
              Row(
                children: [
                  Icon(Icons.schedule_outlined, size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    AppDateUtils.scheduleWindow(job.scheduledStart, job.scheduledEnd),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: job.isOverdue
                          ? Colors.red.shade700
                          : cs.onSurfaceVariant,
                      fontWeight:
                      job.isOverdue ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  // Sync indicator
                  if (!job.isSynced)
                    Row(
                      children: [
                        Icon(Icons.cloud_upload_outlined,
                            size: 14, color: Colors.orange.shade700),
                        const SizedBox(width: 2),
                        Text(
                          'Pending sync',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}