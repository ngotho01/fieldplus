import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/jobs_repository.dart';

// Simple family provider — no code generation needed
final jobDetailProvider =
FutureProvider.family<JobModel?, String>((ref, jobId) {
  return ref.watch(jobsRepositoryProvider).getJobById(jobId);
});