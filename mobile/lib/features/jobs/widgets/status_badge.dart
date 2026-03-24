import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isOverdue;

  const StatusBadge({super.key, required this.status, this.isOverdue = false});

  @override
  Widget build(BuildContext context) {
    if (isOverdue && status != 'completed') {
      return _Badge(label: 'Overdue', color: Colors.red.shade700);
    }
    return switch (status) {
      'pending'     => _Badge(label: 'Pending',     color: Colors.orange.shade700),
      'in_progress' => _Badge(label: 'In Progress', color: Colors.blue.shade700),
      'completed'   => _Badge(label: 'Completed',   color: Colors.green.shade700),
      _             => _Badge(label: status,         color: Colors.grey.shade600),
    };
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}