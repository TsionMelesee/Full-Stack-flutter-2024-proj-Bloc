import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/review/presentation/view/create_review_page.dart';

void main() {
  testWidgets('Widgets are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateReviewPage(jobId: "123"),
      ),
    );

    // Check if the CreateJobPage widget is rendered
    expect(find.byType(CreateReviewPage), findsOneWidget);
    // Check if all necessary widgets inside CreateJobPage are rendered
    expect(find.text('Create Review').first,
        findsOneWidget); // Use find.text('Create Job').first
    expect(find.byType(TextField), findsOneWidget);

    expect(find.byType(ElevatedButton), findsOneWidget);
    // Do not check for DropdownButtonFormField
  });

  testWidgets('Submitting review triggers no error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreateReviewPage(
          jobId: '',
        ),
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
