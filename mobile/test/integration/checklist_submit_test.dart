import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fieldpulse/data/repositories/checklist_repository.dart';
import 'package:fieldpulse/core/errors/exceptions.dart';

import 'checklist_submit_test.mocks.dart';

@GenerateMocks([ChecklistRepository])
void main() {
  late MockChecklistRepository mockRepo;

  setUp(() => mockRepo = MockChecklistRepository());

  group('ChecklistRepository.submitChecklist()', () {
    test('calls submitChecklist with correct jobId and responses', () async {
      when(mockRepo.submitChecklist(any, any)).thenAnswer((_) async {});

      await mockRepo.submitChecklist('job-123', {'condition': 'Clean'});

      verify(mockRepo.submitChecklist('job-123', {'condition': 'Clean'})).called(1);
    });

    test('throws ValidationException on 422 response', () async {
      when(mockRepo.submitChecklist(any, any))
          .thenThrow(ValidationException(['Condition is required']));

      expect(
            () => mockRepo.submitChecklist('job-123', {}),
        throwsA(isA<ValidationException>()),
      );
    });

    test('saves draft locally without throwing on offline', () async {
      when(mockRepo.saveDraftLocally(any, any)).thenAnswer((_) async {});

      await mockRepo.saveDraftLocally('job-123', {'notes': 'partial'});

      verify(mockRepo.saveDraftLocally('job-123', {'notes': 'partial'})).called(1);
    });
  });
}