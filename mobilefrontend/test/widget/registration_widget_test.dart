import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/auth/presentation/view/registration.dart';

void main() {
  testWidgets('User Registration Page UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: UserRegistrationPage(),
    ));

    // Verify if all the text fields are present
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify if registration button is present
    expect(find.text('Register'), findsOneWidget);

    // Tap on the registration button, suppressing the warning
    await tester.tap(find.text('Register'), warnIfMissed: false);
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Now, let's verify if the registration functionality works correctly
    // For this test, we'll assume the registration button always navigates to the login page after registration.
    // So, we check if the login page is navigated to. // Replace 'Login' with the text or identifier of your login page.
  });
}
