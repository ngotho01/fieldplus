import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatetimeFieldWidget extends StatelessWidget {
  final Map<String, dynamic> field;
  final dynamic value;
  final String? error;
  final void Function(dynamic) onChange;

  const DatetimeFieldWidget({
    super.key, required this.field, required this.value,
    required this.error, required this.onChange,
  });

  String? get _display {
    if (value == null) return null;
    final dt = DateTime.tryParse(value as String);
    if (dt == null) return null;
    return DateFormat('MMM d, yyyy h:mm a').format(dt.toLocal());
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;

    final combined = DateTime(
      date.year, date.month, date.day, time.hour, time.minute,
    );
    onChange(combined.toUtc().toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    final label = '${field['label']}${field['required'] == true ? ' *' : ''}';
    return GestureDetector(
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: error,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          _display ?? 'Tap to select date & time',
          style: _display == null
              ? TextStyle(color: Theme.of(context).hintColor)
              : null,
        ),
      ),
    );
  }
}