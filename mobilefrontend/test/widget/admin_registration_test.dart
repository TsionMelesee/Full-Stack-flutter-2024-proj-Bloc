import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/auth/presentation/view/admin_registration_page.dart';
import 'package:mobilefrontend/auth/presentation/view/registration.dart';

void main() {
  testWidgets('Admin Registration Page UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: AdminRegistrationPage(),
    ));

    // Verify if all the text fields are present
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Verify if registration button is present
    expect(find.text('Register'), findsOneWidget);

    await tester.tap(find.text('Register'), warnIfMissed: false);
    await tester.pumpAndSettle();
  });
}
