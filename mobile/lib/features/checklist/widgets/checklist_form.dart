import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/checklist_provider.dart';
import 'fields/text_field_widget.dart';
import 'fields/number_field_widget.dart';
import 'fields/select_field_widget.dart';
import 'fields/multi_select_widget.dart';
import 'fields/datetime_field_widget.dart';
import 'fields/photo_field_widget.dart';
import 'fields/signature_field_widget.dart';
import 'fields/checkbox_field_widget.dart';

class ChecklistForm extends ConsumerStatefulWidget {
  final String jobId;
  final Map<String, dynamic> schema;

  const ChecklistForm({
    super.key,
    required this.jobId,
    required this.schema,
  });

  @override
  ConsumerState<ChecklistForm> createState() => _ChecklistFormState();
}

class _ChecklistFormState extends ConsumerState<ChecklistForm> {
  final _scrollCtrl = ScrollController();
  final Map<String, GlobalKey> _fieldKeys = {};

  List<Map<String, dynamic>> get _fields =>
      (widget.schema['fields'] as List)
          .map((f) => f as Map<String, dynamic>)
          .toList();

  /// Validates a single field on blur and scrolls to it if invalid
  void _onFieldBlur(String fieldId) {
    final notifier = ref.read(checklistProvider(widget.jobId).notifier);
    final field    = _fields.firstWhere((f) => f['id'] == fieldId,
        orElse: () => {});
    if (field.isEmpty) return;
    notifier.validateSingleField(field);
  }

  Future<void> _submit() async {
    final notifier = ref.read(checklistProvider(widget.jobId).notifier);
    final success  = await notifier.submit(_fields);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checklist submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      _scrollToFirstError();
    }
  }

  void _scrollToFirstError() {
    final state = ref.read(checklistProvider(widget.jobId)).valueOrNull;
    if (state == null || state.fieldErrors.isEmpty) return;
    final firstId = state.fieldErrors.keys.first;
    final key     = _fieldKeys[firstId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.2,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final checklistAsync = ref.watch(checklistProvider(widget.jobId));

    return checklistAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error:   (e, _) => Center(child: Text('$e')),
      data:    (state) {
        if (state.submitted) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 72, color: Colors.green),
                const SizedBox(height: 16),
                const Text('Submitted!',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                if (state.submitError != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(state.submitError!,
                        style:
                        const TextStyle(color: Colors.orange)),
                  ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.submitError != null)
                    _ErrorBanner(message: state.submitError!),
                  ..._fields.map((field) {
                    final id = field['id'] as String;
                    _fieldKeys[id] ??= GlobalKey();
                    return Padding(
                      key: _fieldKeys[id],
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildField(field, state),
                    );
                  }),
                ],
              ),
            ),
            _BottomBar(
              isSubmitting: state.isSubmitting,
              onDraft: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Draft saved locally')),
              ),
              onSubmit: _submit,
            ),
          ],
        );
      },
    );
  }

  Widget _buildField(Map<String, dynamic> field, ChecklistState state) {
    final id    = field['id'] as String;
    final type  = field['type'] as String;
    final error = state.fieldErrors[id];
    final value = state.responses[id];

    void onChange(dynamic v) =>
        ref.read(checklistProvider(widget.jobId).notifier).setField(id, v);

    return switch (type) {
      'text' => TextFieldWidget(
          field: field, value: value, error: error,
          onChange: onChange, onBlur: _onFieldBlur),
      'textarea' => TextFieldWidget(
          field: field, value: value, error: error,
          onChange: onChange, onBlur: _onFieldBlur, multiLine: true),
      'number' => NumberFieldWidget(
          field: field, value: value, error: error,
          onChange: onChange, onBlur: _onFieldBlur),
      'select'       => SelectFieldWidget(
          field: field, value: value, error: error, onChange: onChange),
      'multi_select' => MultiSelectWidget(
          field: field, value: value, error: error, onChange: onChange),
      'datetime'     => DatetimeFieldWidget(
          field: field, value: value, error: error, onChange: onChange),
      'photo'        => PhotoFieldWidget(
          field: field, value: value, error: error,
          onChange: onChange, jobId: widget.jobId),
      'signature'    => SignatureFieldWidget(
          field: field, value: value, error: error,
          onChange: onChange, jobId: widget.jobId),
      'checkbox'     => CheckboxFieldWidget(
          field: field, value: value, error: error, onChange: onChange),
      _ => Text('Unknown field type: $type'),
    };
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Icon(Icons.error_outline, color: cs.onErrorContainer, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message,
              style: TextStyle(color: cs.onErrorContainer)),
        ),
      ]),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onDraft;
  final VoidCallback onSubmit;
  const _BottomBar(
      {required this.isSubmitting,
        required this.onDraft,
        required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: isSubmitting ? null : onDraft,
                child: const Text('Save Draft'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}