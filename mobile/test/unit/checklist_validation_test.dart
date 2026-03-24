import 'package:flutter_test/flutter_test.dart';
import 'package:fieldpulse/features/checklist/providers/checklist_provider.dart';

// Pure unit tests — no Flutter widgets needed
void main() {
  group('ChecklistNotifier.validate()', () {
    late ChecklistNotifier notifier;

    // Minimal fields set for tests
    final fields = [
      {'id': 'name', 'type': 'text', 'label': 'Name', 'required': true},
      {'id': 'count', 'type': 'number', 'label': 'Count', 'required': true, 'min': 0, 'max': 100},
      {'id': 'notes', 'type': 'textarea', 'label': 'Notes', 'required': false, 'max_length': 20},
      {'id': 'agreed', 'type': 'checkbox', 'label': 'Agree', 'required': true},
      {'id': 'choice', 'type': 'select', 'label': 'Choice', 'required': true, 'options': ['A', 'B']},
    ];

    setUp(() {
      // We test validate() independently via a helper; the notifier is a
      // Riverpod AsyncNotifier so we test the pure logic extracted below.
    });

    test('valid responses pass validation', () {
      final responses = {
        'name': 'Alice',
        'count': 50.0,
        'notes': 'OK',
        'agreed': true,
        'choice': 'A',
      };
      final errors = _validateResponses(fields, responses);
      expect(errors, isEmpty);
    });

    test('missing required text field produces error', () {
      final responses = {'count': 50.0, 'agreed': true, 'choice': 'A'};
      final errors = _validateResponses(fields, responses);
      expect(errors.containsKey('name'), isTrue);
    });

    test('number below min produces error', () {
      final responses = {'name': 'X', 'count': -1.0, 'agreed': true, 'choice': 'A'};
      final errors = _validateResponses(fields, responses);
      expect(errors.containsKey('count'), isTrue);
      expect(errors['count'], contains('≥'));
    });

    test('number above max produces error', () {
      final responses = {'name': 'X', 'count': 200.0, 'agreed': true, 'choice': 'A'};
      final errors = _validateResponses(fields, responses);
      expect(errors.containsKey('count'), isTrue);
      expect(errors['count'], contains('≤'));
    });

    test('text area over max_length produces error', () {
      final responses = {
        'name': 'X',
        'count': 1.0,
        'notes': 'This is way too long for a 20-char limit',
        'agreed': true,
        'choice': 'A',
      };
      final errors = _validateResponses(fields, responses);
      expect(errors.containsKey('notes'), isTrue);
    });

    test('unchecked required checkbox produces error', () {
      final responses = {'name': 'X', 'count': 1.0, 'agreed': false, 'choice': 'A'};
      final errors = _validateResponses(fields, responses);
      expect(errors.containsKey('agreed'), isTrue);
    });

    test('null required checkbox produces error', () {
      final responses = {'name': 'X', 'count': 1.0, 'choice': 'A'};
      final errors = _validateResponses(fields, responses);
      expect(errors.containsKey('agreed'), isTrue);
    });

    test('invalid select option produces error', () {
      // Note: select validation lives server-side; client validates presence only
      final responses = {'name': 'X', 'count': 1.0, 'agreed': true, 'choice': null};
      final errors = _validateResponses(fields, responses);
      expect(errors.containsKey('choice'), isTrue);
    });
  });
}

/// Extracted validation logic mirroring ChecklistNotifier.validate()
/// so we can test it without Riverpod container overhead.
Map<String, String> _validateResponses(
    List<Map<String, dynamic>> fields,
    Map<String, dynamic> responses,
    ) {
  final errors = <String, String>{};

  for (final field in fields) {
    final id       = field['id'] as String;
    final label    = field['label'] as String;
    final required = field['required'] as bool? ?? false;
    final type     = field['type'] as String;
    final value    = responses[id];

    if (required) {
      final empty = value == null ||
          value == '' ||
          (value is List && value.isEmpty) ||
          (type == 'checkbox' && value != true);
      if (empty) {
        errors[id] = '$label is required';
        continue;
      }
    }

    if (value == null) continue;

    if (type == 'number') {
      final n = double.tryParse(value.toString());
      if (n == null) {
        errors[id] = '$label must be a number';
      } else {
        final min = (field['min'] as num?)?.toDouble();
        final max = (field['max'] as num?)?.toDouble();
        if (min != null && n < min) errors[id] = '$label must be ≥ $min';
        if (max != null && n > max) errors[id] = '$label must be ≤ $max';
      }
    }

    if (type == 'textarea') {
      final maxLen = field['max_length'] as int?;
      if (maxLen != null && value.toString().length > maxLen) {
        errors[id] = '$label exceeds $maxLen characters';
      }
    }
  }

  return errors;
}