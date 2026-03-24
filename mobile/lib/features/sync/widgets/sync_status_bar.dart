import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/sync_service.dart';

class SyncStatusBar extends ConsumerWidget {
  const SyncStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncAsync = ref.watch(syncServiceProvider);
    final pending   = ref.watch(pendingCountProvider);

    return syncAsync.when(
      loading: () => const _Bar(
        color: Colors.blue,
        icon: Icons.sync,
        message: 'Syncing…',
        spinning: true,
      ),
      error: (e, _) => _Bar(
        color: Colors.red,
        icon: Icons.error_outline,
        message: 'Sync failed — tap to retry',
        onTap: () => ref.read(syncServiceProvider.notifier).syncAll(),
      ),
      data: (state) {
        return switch (state.status) {
          SyncStatus.syncing => const _Bar(
            color: Colors.blue,
            icon: Icons.sync,
            message: 'Syncing…',
            spinning: true,
          ),
          SyncStatus.offline => _Bar(
            color: Colors.orange,
            icon: Icons.wifi_off_outlined,
            message: pending > 0
                ? '$pending item${pending > 1 ? 's' : ''} pending — offline'
                : 'Offline',
            onTap: () => ref.read(syncServiceProvider.notifier).syncAll(),
          ),
          SyncStatus.error => _Bar(
            color: Colors.red,
            icon: Icons.error_outline,
            message: 'Sync failed — tap to retry',
            onTap: () => ref.read(syncServiceProvider.notifier).syncAll(),
          ),
          SyncStatus.done => const SizedBox.shrink(),
          SyncStatus.idle => pending > 0
              ? _Bar(
            color: Colors.orange,
            icon: Icons.cloud_upload_outlined,
            message: '$pending item${pending > 1 ? 's' : ''} pending upload',
            onTap: () => ref.read(syncServiceProvider.notifier).syncAll(),
          )
              : const SizedBox.shrink(),
        };
      },
    );
  }
}

class _Bar extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String message;
  final bool spinning;
  final VoidCallback? onTap;

  const _Bar({
    required this.color,
    required this.icon,
    required this.message,
    this.spinning = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color.withOpacity(0.12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            spinning
                ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            )
                : Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}