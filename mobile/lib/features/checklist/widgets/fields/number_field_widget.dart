import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberFieldWidget extends StatefulWidget {
  final Map<String, dynamic> field;
  final dynamic value;
  final String? error;
  final void Function(dynamic) onChange;
  final void Function(String fieldId)? onBlur;

  const NumberFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.error,
    required this.onChange,
    this.onBlur,
  });

  @override
  State<NumberFieldWidget> createState() => _NumberFieldWidgetState();
}

class _NumberFieldWidgetState extends State<NumberFieldWidget> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl  = TextEditingController(text: widget.value?.toString() ?? '');
    _focus = FocusNode();
    _focus.addListener(() {
      if (!_focus.hasFocus) {
        widget.onBlur?.call(widget.field['id'] as String);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final min   = widget.field['min'];
    final max   = widget.field['max'];
    final label = '${widget.field['label']}'
        '${widget.field['required'] == true ? ' *' : ''}';
    String? hint;
    if (min != null && max != null) hint = '$min – $max';

    return TextField(
      controller: _ctrl,
      focusNode:  _focus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
      ],
      onChanged: (v) => widget.onChange(double.tryParse(v) ?? v),
      decoration: InputDecoration(
        labelText: label,
        hintText:  hint,
        errorText: widget.error,
      ),
    );
  }
}