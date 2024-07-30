import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/presentation/view/review_edit_page.dart';

void main() {
  testWidgets('Edit Review UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: EditReviewPage(
          review: Review(
            jobId: '1',
            reviewId: '123',
            content: 'fine',
            rate: 3,
            authorId: 4,
          ),
        ),
      ),
    );

    // Find widgets by their text and verify their existence.
    expect(find.text('Update Review'), findsOneWidget);
    expect(find.text('Rating:'), findsOneWidget);
    expect(find.text('Update Review'), findsOneWidget);
  });
}
