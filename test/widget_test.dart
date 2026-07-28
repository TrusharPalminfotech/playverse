import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playverseadmin/main.dart';

void configureViewSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('Login screen loads and displays essential elements', (
    WidgetTester tester,
  ) async {
    configureViewSize(tester);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify system login header is visible
    expect(find.text('System Login'), findsOneWidget);

    // Verify email and password fields exist
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verify role tabs are present
    expect(find.text('Super Admin'), findsOneWidget);
    expect(find.text('Ground Partner'), findsOneWidget);
    expect(find.text('Organizer'), findsOneWidget);
  });

  testWidgets('Submitting empty form triggers validation errors', (
    WidgetTester tester,
  ) async {
    configureViewSize(tester);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the 'SECURE LOG IN' button.
    final loginButtonFinder = find.text('SECURE LOG IN');
    expect(loginButtonFinder, findsOneWidget);
    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle();

    // Verify validation errors are shown on screen
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Entering invalid email format triggers validation error', (
    WidgetTester tester,
  ) async {
    configureViewSize(tester);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Enter invalid email into the first TextFormField (email field)
    final emailFieldFinder = find.byType(TextFormField).first;
    await tester.enterText(emailFieldFinder, 'invalidemail');

    // Tap the login button
    await tester.tap(find.text('SECURE LOG IN'));
    await tester.pumpAndSettle();

    // Verify correct error messages
    expect(find.text('Please enter a valid email address'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Entering valid credentials and submitting triggers loading state', (
    WidgetTester tester,
  ) async {
    configureViewSize(tester);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Enter valid email and password
    final emailFieldFinder = find.byType(TextFormField).first;
    final passwordFieldFinder = find.byType(TextFormField).at(1);

    await tester.enterText(emailFieldFinder, 'admin@playverse.com');
    await tester.enterText(passwordFieldFinder, 'password123');

    // Tap the login button
    await tester.tap(find.text('SECURE LOG IN'));
    await tester.pump(); // Start execution

    // Verify the loading indicator is shown (ElevatedButton replacement/loading state)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the simulated delay and snackbar animation to complete so no timers are left pending
    await tester.pumpAndSettle();
  });
}
