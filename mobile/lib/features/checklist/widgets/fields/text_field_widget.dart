import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final Map<String, dynamic> field;
  final dynamic value;
  final String? error;
  final void Function(dynamic) onChange;
  final void Function(String fieldId)? onBlur;
  final bool multiLine;

  const TextFieldWidget({
    super.key,
    required this.field,
    required this.value,
    required this.error,
    required this.onChange,
    this.onBlur,
    this.multiLine = false,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl  = TextEditingController(text: widget.value?.toString() ?? '');
    _focus = FocusNode();
    _focus.addListener(() {
      // Fire onBlur when focus is lost
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
    final maxLen = widget.field['max_length'] as int?;
    final label  = '${widget.field['label']}'
        '${widget.field['required'] == true ? ' *' : ''}';

    return TextField(
      controller: _ctrl,
      focusNode:  _focus,
      maxLines:   widget.multiLine ? 4 : 1,
      maxLength:  maxLen,
      onChanged:  widget.onChange,
      decoration: InputDecoration(
        labelText: label,
        errorText: widget.error,
        alignLabelWithHint: widget.multiLine,
      ),
    );
  }
}