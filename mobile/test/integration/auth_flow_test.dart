import 'package:fieldpulse/core/errors/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fieldpulse/data/repositories/auth_repository.dart';
import 'package:fieldpulse/features/auth/providers/auth_provider.dart';
import 'package:fieldpulse/features/auth/screens/login_screen.dart';
import 'package:fieldpulse/router/app_router.dart';

import 'auth_flow_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepo;

  setUp(() => mockRepo = MockAuthRepository());

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: Consumer(
        builder: (_, ref, __) => MaterialApp.router(
          routerConfig: ref.watch(appRouterProvider),
        ),
      ),
    );
  }

  testWidgets('shows login screen when not authenticated', (tester) async {
    when(mockRepo.getCachedUser()).thenAnswer((_) async => null);
    when(mockRepo.hasValidSession()).thenAnswer((_) async => false);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('login with valid credentials navigates to jobs', (tester) async {
    final fakeUser = AuthUser(
      id: '1', email: 'tech@fp.com',
      firstName: 'John', lastName: 'Tech',
    );
    when(mockRepo.login(any, any)).thenAnswer((_) async => fakeUser);
    when(mockRepo.getCachedUser()).thenAnswer((_) async => null);
    when(mockRepo.hasValidSession()).thenAnswer((_) async => false);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'tech@fp.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // After login, router should redirect to /jobs
    expect(find.text('My Jobs'), findsOneWidget);
  });

  testWidgets('shows error message on invalid credentials', (tester) async {
    when(mockRepo.login(any, any))
        .thenThrow(const AuthException('Invalid email or password.'));
    when(mockRepo.getCachedUser()).thenAnswer((_) async => null);
    when(mockRepo.hasValidSession()).thenAnswer((_) async => false);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'bad@fp.com');
    await tester.enterText(find.byType(TextFormField).last, 'wrong');
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password.'), findsOneWidget);
  });
}