import 'package:flutter/material.dart';

class SelectFieldWidget extends StatelessWidget {
  final Map<String, dynamic> field;
  final dynamic value;
  final String? error;
  final void Function(dynamic) onChange;

  const SelectFieldWidget({
    super.key, required this.field, required this.value,
    required this.error, required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final options = (field['options'] as List).cast<String>();
    final label = '${field['label']}${field['required'] == true ? ' *' : ''}';

    return DropdownButtonFormField<String>(
      value: value as String?,
      decoration: InputDecoration(labelText: label, errorText: error),
      items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
      onChanged: (v) => onChange(v),
    );
  }
}