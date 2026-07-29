// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:playverseadmin/screens/login_screen.dart';
import 'package:playverseadmin/services/auth_service.dart';

import 'auth_service_test.mocks.dart';

int totalCases = 0;
int passedCases = 0;
int failedCases = 0;

void runTest(String description, dynamic Function() body) {
  totalCases++;
  test(description, () async {
    print('Runnig Test: $description');
    try {
      await body();
      passedCases++;
      print('Passed Test: $description');
    } catch (e) {
      failedCases++;
      print('Failed Test: $description - Error: $e');
      rethrow;
    }
  });
}

void runWidgetTest(
  String description,
  Future<void> Function(WidgetTester) body,
) {
  totalCases++;
  testWidgets(description, (WidgetTester tester) async {
    print('Running Widget Test: $description');
    try {
      await body(tester);
      passedCases++;
      print('Passed Widget Test: $description');
    } catch (e) {
      failedCases++;
      print('Failed Widget Test: $description - Error: $e');
      rethrow;
    }
  });
}

@GenerateMocks([AuthService])
void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  void configureViewSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  tearDownAll(() {
    print('\n=======================================');
    print('AUTH SERVICE MOCK TEST SUMMARY:');
    print('Total Cases: $totalCases');
    print('Passed Cases: $passedCases');
    print('Failed Cases: $failedCases');
    print('=======================================\n');
  });

  group('AuthService Mock Unit Tests', () {
    runTest('returns true on successful mock login', () async {
      when(
        mockAuthService.login(
          'admin@playverse.com',
          'password123',
          'Super Admin',
        ),
      ).thenAnswer((_) async => true);

      final result = await mockAuthService.login(
        'admin@playverse.com',
        'password123',
        'Super Admin',
      );

      expect(result, isTrue);
      verify(
        mockAuthService.login(
          'admin@playverse.com',
          'password123',
          'Super Admin',
        ),
      ).called(1);
    });

    runTest('returns false on failed mock login', () async {
      when(
        mockAuthService.login(
          'invalid@playverse.com',
          'wrongpassword',
          'Super Admin',
        ),
      ).thenAnswer((_) async => false);

      final result = await mockAuthService.login(
        'invalid@playverse.com',
        'wrongpassword',
        'Super Admin',
      );

      expect(result, isFalse);
      verify(
        mockAuthService.login(
          'invalid@playverse.com',
          'wrongpassword',
          'Super Admin',
        ),
      ).called(1);
    });
  });

  group('LoginScreen Widget Tests with MockAuthService', () {
    runWidgetTest('displays error snackbar when auth fails', (
      WidgetTester tester,
    ) async {
      configureViewSize(tester);

      // Stub MockAuthService to return false (failed login) after a brief delay
      when(mockAuthService.login(any, any, any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return false;
      });

      // Build our app and inject the mockAuthService
      await tester.pumpWidget(
        MaterialApp(home: LoginScreen(authService: mockAuthService)),
      );

      // Enter credentials
      final emailFieldFinder = find.byType(TextFormField).first;
      final passwordFieldFinder = find.byType(TextFormField).at(1);
      await tester.enterText(emailFieldFinder, 'admin@playverse.com');
      await tester.enterText(passwordFieldFinder, 'password123');

      // Tap log in
      await tester.tap(find.text('SECURE LOG IN'));
      await tester.pump(); // Start request, show loading

      // Verify progress indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Settle animation (this fires the Future.then and triggers the snackbar)
      await tester.pumpAndSettle();

      // Verify the failure snackbar is visible
      expect(find.text('Error: Authentication failed!'), findsOneWidget);
    });

    runWidgetTest('displays success snackbar when auth succeeds', (
      WidgetTester tester,
    ) async {
      configureViewSize(tester);

      // Stub MockAuthService to return true (successful login) after a brief delay
      when(mockAuthService.login(any, any, any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return true;
      });

      // Build our app and inject the mockAuthService
      await tester.pumpWidget(
        MaterialApp(home: LoginScreen(authService: mockAuthService)),
      );

      // Enter credentials
      final emailFieldFinder = find.byType(TextFormField).first;
      final passwordFieldFinder = find.byType(TextFormField).at(1);
      await tester.enterText(emailFieldFinder, 'admin@playverse.com');
      await tester.enterText(passwordFieldFinder, 'password123');

      // Tap log in
      await tester.tap(find.text('SECURE LOG IN'));
      await tester.pump(); // Start request

      await tester.pumpAndSettle();

      // Verify the success snackbar is visible
      expect(
        find.text('Success: Authenticated as Super Admin!'),
        findsOneWidget,
      );
    });
  });
}
