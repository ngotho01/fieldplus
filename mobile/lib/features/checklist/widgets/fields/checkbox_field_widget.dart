import 'package:flutter/material.dart';

class CheckboxFieldWidget extends StatelessWidget {
  final Map<String, dynamic> field;
  final dynamic value;
  final String? error;
  final void Function(dynamic) onChange;

  const CheckboxFieldWidget({
    super.key, required this.field, required this.value,
    required this.error, required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text(
            '${field['label']}${field['required'] == true ? ' *' : ''}',
          ),
          value: (value as bool?) ?? false,
          onChanged: (v) => onChange(v),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: error != null ? Colors.red.shade50 : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: error != null
                ? BorderSide(color: Theme.of(context).colorScheme.error)
                : BorderSide.none,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              error!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}