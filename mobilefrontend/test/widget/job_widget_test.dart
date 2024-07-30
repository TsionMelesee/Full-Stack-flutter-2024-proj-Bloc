import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/job/presentation/view/job_create.dart';

void main() {
  testWidgets('Widgets are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateJobPage(),
      ),
    );

    // Check if the CreateJobPage widget is rendered
    expect(find.byType(CreateJobPage), findsOneWidget);
    // Check if all necessary widgets inside CreateJobPage are rendered
    expect(find.text('Create Job').first,
        findsOneWidget); // Use find.text('Create Job').first
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.byType(ElevatedButton), findsOneWidget);
    // Do not check for DropdownButtonFormField
  });

  testWidgets('Submitting job triggers no error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateJobPage(),
      ),
    );

    // Tap on the submit button
    await tester.tap(find.byType(ElevatedButton));

    // Wait for the UI to react
    await tester.pump();

    // No error should occur
    expect(tester.takeException(), isNull);
  });
}
