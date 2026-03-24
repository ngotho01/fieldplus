import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/jobs/screens/job_list_screen.dart';
import '../features/jobs/screens/job_detail_screen.dart';
import '../features/checklist/screens/checklist_screen.dart';
import '../services/notification_service.dart';


class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  bool _isLoggedIn = false;
  bool _isLoading  = true;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading  => _isLoading;

  RouterNotifier(this._ref) {
    // Sync current state immediately (handles app restart with saved session)
    final current = _ref.read(authNotifierProvider);
    _isLoading  = current.isLoading;
    _isLoggedIn = current.valueOrNull?.isLoggedIn ?? false;

    // Listen for ALL future auth state changes
    _ref.listen<AsyncValue<AuthStateData>>(
      authNotifierProvider,
          (_, next) {
        _isLoading  = next.isLoading;
        _isLoggedIn = next.valueOrNull?.isLoggedIn ?? false;
        notifyListeners(); // triggers GoRouter to re-run redirect()
      },
    );
  }
}

final _routerNotifierProvider = Provider<RouterNotifier>(
      (ref) => RouterNotifier(ref),
);

// ── Router ────────────────────────────────────────────────────────────────────

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(_routerNotifierProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/jobs',
    refreshListenable: notifier,
    redirect: (context, state) {
      // Read from notifier fields — always current, never stale
      final isLoggedIn  = notifier.isLoggedIn;
      final isLoading   = notifier.isLoading;
      final isLoggingIn = state.matchedLocation == '/login';

      if (isLoading) return null; // wait for auth check to complete

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn  &&  isLoggingIn) return '/jobs';

      // Deep-link from notification tap
      if (isLoggedIn) {
        final jobId = NotificationService.pendingJobId;
        if (jobId != null) {
          NotificationService.pendingJobId = null;
          return '/jobs/$jobId';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/jobs',
        name: 'jobs',
        builder: (_, __) => const JobListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'job-detail',
            builder: (_, state) => JobDetailScreen(
              jobId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'checklist',
                name: 'checklist',
                builder: (_, state) => ChecklistScreen(
                  jobId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
});