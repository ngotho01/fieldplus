import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/exceptions.dart';
import '../../../data/repositories/checklist_repository.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class ChecklistState {
  final Map<String, dynamic> responses;
  final Map<String, String> fieldErrors;
  final bool isSubmitting;
  final bool isDirty;
  final String? submitError;
  final bool submitted;

  const ChecklistState({
    this.responses   = const {},
    this.fieldErrors = const {},
    this.isSubmitting = false,
    this.isDirty     = false,
    this.submitError,
    this.submitted   = false,
  });

  ChecklistState copyWith({
    Map<String, dynamic>? responses,
    Map<String, String>? fieldErrors,
    bool? isSubmitting,
    bool? isDirty,
    String? submitError,
    bool clearError = false,
    bool? submitted,
  }) =>
      ChecklistState(
        responses:    responses    ?? this.responses,
        fieldErrors:  fieldErrors  ?? this.fieldErrors,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isDirty:      isDirty      ?? this.isDirty,
        submitError:  clearError   ? null : (submitError ?? this.submitError),
        submitted:    submitted    ?? this.submitted,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class ChecklistNotifier extends FamilyAsyncNotifier<ChecklistState, String> {
  @override
  Future<ChecklistState> build(String arg) async {
    final repo  = ref.read(checklistRepositoryProvider);
    final saved = await repo.getDraftResponses(arg);
    return ChecklistState(responses: saved ?? {});
  }

  String get _jobId => arg;

  // ── Field change ────────────────────────────────────────────────────────────

  void setField(String fieldId, dynamic value) {
    final current   = state.valueOrNull ?? const ChecklistState();
    final responses = Map<String, dynamic>.from(current.responses)
      ..[fieldId]   = value;
    final errors    = Map<String, String>.from(current.fieldErrors)
      ..remove(fieldId);

    state = AsyncData(current.copyWith(
      responses:  responses,
      fieldErrors: errors,
      isDirty:    true,
      clearError: true,
    ));

    _saveDraft(responses);
  }

  Future<void> _saveDraft(Map<String, dynamic> responses) async {
    try {
      await ref
          .read(checklistRepositoryProvider)
          .saveDraftLocally(_jobId, responses);
    } catch (_) {}
  }

  // ── Single-field validation (called on blur) ────────────────────────────────

  void validateSingleField(Map<String, dynamic> field) {
    final current  = state.valueOrNull ?? const ChecklistState();
    final id       = field['id']       as String;
    final label    = field['label']    as String;
    final required = field['required'] as bool? ?? false;
    final type     = field['type']     as String;
    final value    = current.responses[id];

    String? error;

    // Required check
    if (required) {
      final isEmpty = value == null ||
          value == '' ||
          (value is List && value.isEmpty) ||
          (type == 'checkbox' && value != true);
      if (isEmpty) error = '$label is required';
    }

    // Type-specific check (only if no required error yet)
    if (error == null && value != null) {
      if (type == 'number') {
        final parsed = double.tryParse(value.toString());
        if (parsed == null) {
          error = '$label must be a number';
        } else {
          final minVal = (field['min'] as num?)?.toDouble();
          final maxVal = (field['max'] as num?)?.toDouble();
          if (minVal != null && parsed < minVal) {
            error = '$label must be ≥ $minVal';
          }
          if (maxVal != null && parsed > maxVal) {
            error = '$label must be ≤ $maxVal';
          }
        }
      }

      if (type == 'textarea') {
        final maxLen = field['max_length'] as int?;
        if (maxLen != null && value.toString().length > maxLen) {
          error = '$label exceeds $maxLen characters';
        }
      }
    }

    final errors = Map<String, String>.from(current.fieldErrors);
    if (error != null) {
      errors[id] = error;
    } else {
      errors.remove(id);
    }

    state = AsyncData(current.copyWith(fieldErrors: errors));
  }

  // ── Full validation (called on submit) ─────────────────────────────────────

  bool validate(List<Map<String, dynamic>> fields) {
    final current = state.valueOrNull ?? const ChecklistState();
    final errors  = <String, String>{};

    for (final field in fields) {
      final id       = field['id']       as String;
      final label    = field['label']    as String;
      final required = field['required'] as bool? ?? false;
      final type     = field['type']     as String;
      final value    = current.responses[id];

      // Required check
      if (required) {
        final isEmpty = value == null ||
            value == '' ||
            (value is List   && value.isEmpty) ||
            (type == 'checkbox' && value != true);
        if (isEmpty) {
          errors[id] = '$label is required';
          continue;
        }
      }

      if (value == null) continue;

      // Type-specific checks
      if (type == 'number') {
        final parsed = double.tryParse(value.toString());
        if (parsed == null) {
          errors[id] = '$label must be a number';
        } else {
          final minVal = (field['min'] as num?)?.toDouble();
          final maxVal = (field['max'] as num?)?.toDouble();
          if (minVal != null && parsed < minVal) {
            errors[id] = '$label must be ≥ $minVal';
          }
          if (maxVal != null && parsed > maxVal) {
            errors[id] = '$label must be ≤ $maxVal';
          }
        }
      }

      if (type == 'textarea') {
        final maxLen = field['max_length'] as int?;
        if (maxLen != null && value.toString().length > maxLen) {
          errors[id] = '$label exceeds $maxLen characters';
        }
      }
    }

    state = AsyncData(
      (state.valueOrNull ?? const ChecklistState())
          .copyWith(fieldErrors: errors),
    );
    return errors.isEmpty;
  }

  // ── Submit ──────────────────────────────────────────────────────────────────

  Future<bool> submit(List<Map<String, dynamic>> fields) async {
    if (!validate(fields)) return false;

    final current = state.valueOrNull ?? const ChecklistState();
    state = AsyncData(current.copyWith(
      isSubmitting: true,
      clearError:   true,
    ));

    try {
      await ref
          .read(checklistRepositoryProvider)
          .submitChecklist(_jobId, current.responses);

      state = AsyncData(current.copyWith(
        isSubmitting: false,
        submitted:    true,
        isDirty:      false,
        clearError:   true,
      ));
      return true;
    } on ValidationException catch (e) {
      state = AsyncData(current.copyWith(
        isSubmitting: false,
        submitError:  e.message,
      ));
      return false;
    } catch (_) {
      // Offline or other error — queued for sync
      state = AsyncData(current.copyWith(
        isSubmitting: false,
        submitted:    true,
        submitError:  'Saved locally — will sync when online.',
      ));
      return true;
    }
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final checklistProvider = AsyncNotifierProvider.family<
    ChecklistNotifier,
    ChecklistState,
    String>(ChecklistNotifier.new);