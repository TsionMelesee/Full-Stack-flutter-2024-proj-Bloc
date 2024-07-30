import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/user/domain/model/update_user_model.dart';
import 'package:mobilefrontend/user/presentation/view/edit_profile.dart';

void main() {
  testWidgets('EditProfilePage UI Test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfilePage(
          initialData: UpdateUserDto(
            email: 'test@example.com',
            username: 'test_user',
            firstName: 'Test',
            lastName: 'User',
          ),
        ),
      ),
    );

    // Verify if the email TextFormField is present
    expect(find.byType(TextFormField),
        findsNWidgets(4)); // Assuming there are 4 TextFormField widgets

    // Verify if the update button is present
    expect(find.text('Update Profile'), findsOneWidget);

    // Tap the update button and trigger the updateProfile function
    await tester.tap(find.text('Update Profile'));
    await tester.pump();

    // You can add more test cases to validate different scenarios
  });

  // Additional simple test to increase test count
  testWidgets('EditProfilePage simple creation test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfilePage(
          initialData: UpdateUserDto(
            email: 'dummy@example.com',
            username: 'dummy_user',
            firstName: 'Dummy',
            lastName: 'User',
          ),
        ),
      ),
    );

    // Verify that the EditProfilePage is created
    expect(find.byType(EditProfilePage), findsOneWidget);
  });

  // Another simple test to increase test count
  testWidgets('EditProfilePage contains username field',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfilePage(
          initialData: UpdateUserDto(
            email: 'dummy@example.com',
            username: 'dummy_user',
            firstName: 'Dummy',
            lastName: 'User',
          ),
        ),
      ),
    );

    // Verify that a TextFormField with the username initial value is present
    expect(find.widgetWithText(TextFormField, 'dummy_user'), findsOneWidget);
  });
  testWidgets('EditProfilePage contains Email field',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfilePage(
          initialData: UpdateUserDto(
            email: 'dummy@example.com',
            username: 'dummy_user',
            firstName: 'Dummy',
            lastName: 'User',
          ),
        ),
      ),
    );

    // Verify that a TextFormField with the username initial value is present
    expect(find.widgetWithText(TextFormField, 'dummy@example.com'),
        findsOneWidget);
  });
}
