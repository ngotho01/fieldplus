import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/repositories/jobs_repository.dart';
import '../providers/checklist_provider.dart';
import '../widgets/checklist_form.dart';
import '../../jobs/providers/job_detail_provider.dart';

class ChecklistScreen extends ConsumerWidget {
  final String jobId;
  const ChecklistScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(jobDetailProvider(jobId));

    return Scaffold(
      appBar: AppBar(title: const Text('Checklist')),
      body: jobAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (job) {
          if (job == null) return const Center(child: Text('Job not found'));
          final schema = job.checklistSchema;
          if (schema == null) {
            return const Center(child: Text('No checklist for this job'));
          }
          return ChecklistForm(jobId: jobId, schema: schema);
        },
      ),
    );
  }
}