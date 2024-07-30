import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/review/presentation/view/create_review_page.dart';

void main() {
  testWidgets('Submitting Job triggers no error', (WidgetTester tester) async {
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
