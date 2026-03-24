import 'package:flutter/material.dart';

class MultiSelectWidget extends StatelessWidget {
  final Map<String, dynamic> field;
  final dynamic value;
  final String? error;
  final void Function(dynamic) onChange;

  const MultiSelectWidget({
    super.key, required this.field, required this.value,
    required this.error, required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final options  = (field['options'] as List).cast<String>();
    final selected = (value as List<dynamic>?)?.cast<String>() ?? <String>[];
    final label    = '${field['label']}${field['required'] == true ? ' *' : ''}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((opt) {
            final isSelected = selected.contains(opt);
            return FilterChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (_) {
                final next = List<String>.from(selected);
                isSelected ? next.remove(opt) : next.add(opt);
                onChange(next);
              },
            );
          }).toList(),
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
        ],
      ],
    );
  }
}