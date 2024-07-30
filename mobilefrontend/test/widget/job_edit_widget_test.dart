import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/job/domain/model/job_model.dart';
import 'package:mobilefrontend/job/presentation/view/job_edit.dart';

void main() {
  testWidgets('Edit Job Page UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: EditJobPage(
          jobId: '1',
          job: Job(
            jobId: '1',
            title: 'Software Engineer',
            description: 'Develop mobile applications',
            salary: 50000,
            phonenumber: '+1234567890',
            createrId: 1,
            userType: UserType.EMPLOYEE,
          ),
        ),
      ),
    );

    // Find widgets by their text and verify their existence.
    expect(find.text('Edit Job'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Phone number'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Update Job'), findsOneWidget);
  });
}
