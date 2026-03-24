import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fieldpulse/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FieldPulse E2E — Login → Jobs → Checklist → Submit', () {
    testWidgets('complete happy path flow', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ── 1. Login screen is shown ────────────────────────────────────────
      expect(find.text('FieldPulse'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      // ── 2. Enter credentials ────────────────────────────────────────────
      await tester.enterText(
        find.byType(TextFormField).first,
        'tech@fieldpulse.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );

      // ── 3. Submit login ─────────────────────────────────────────────────
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // ── 4. Jobs list is shown ───────────────────────────────────────────
      expect(find.text('My Jobs'), findsOneWidget);

      // Wait for jobs to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ── 5. Tap first job card ───────────────────────────────────────────
      final firstCard = find.byType(Card).first;
      await tester.tap(firstCard);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // ── 6. Job detail screen shown ──────────────────────────────────────
      expect(find.text('Job Details'), findsOneWidget);
      expect(find.text('Customer'),    findsOneWidget);

      // ── 7. Start the job ────────────────────────────────────────────────
      final startBtn = find.text('Start Job');
      if (startBtn.evaluate().isNotEmpty) {
        await tester.tap(startBtn);
        await tester.pumpAndSettle();
        // Confirm dialog
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }

      // ── 8. Open checklist ───────────────────────────────────────────────
      final checklistBtn = find.text('Open Checklist');
      if (checklistBtn.evaluate().isNotEmpty) {
        await tester.tap(checklistBtn);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.text('Checklist'), findsOneWidget);

        // ── 9. Fill a text/textarea field if present ──────────────────────
        final textFields = find.byType(TextField);
        if (textFields.evaluate().isNotEmpty) {
          await tester.enterText(textFields.first, 'Test entry');
          await tester.pumpAndSettle();
        }

        // ── 10. Tap Save Draft ────────────────────────────────────────────
        await tester.tap(find.text('Save Draft'));
        await tester.pumpAndSettle();
        expect(find.text('Draft saved locally'), findsOneWidget);
      }

      // ── 11. Navigate back ────────────────────────────────────────────────
      final backBtn = find.byTooltip('Back');
      if (backBtn.evaluate().isNotEmpty) {
        await tester.tap(backBtn);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('filter by status shows correct jobs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login
      await tester.enterText(
          find.byType(TextFormField).first, 'tech@fieldpulse.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap "Pending" chip
      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // All visible status badges should be Pending
      expect(find.text('Pending'), findsWidgets);
      expect(find.text('Completed'), findsNothing);
    });

    testWidgets('pull to refresh reloads jobs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.enterText(
          find.byType(TextFormField).first, 'tech@fieldpulse.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Pull to refresh
      await tester.fling(
        find.byType(ListView).first,
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('My Jobs'), findsOneWidget);
    });
  });
}