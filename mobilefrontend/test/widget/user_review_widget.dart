import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobilefrontend/job/presentation/view/jobs_review.dart';
import 'package:mobilefrontend/review/application/bloc/review_event.dart';
import 'package:mobilefrontend/review/application/bloc/review_state.dart';
import 'package:mobilefrontend/review/infrastructure/repostory/review_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilefrontend/review/application/bloc/review_bloc.dart';
import 'package:mobilefrontend/review/infrastructure/data_provider/review_data_provider.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';

void main() {
  testWidgets('User ReviewsPage renders correctly',
      (WidgetTester tester) async {
    // Initialize Dio instance
    final Dio dio = Dio();

    // Initialize SharedPreferences instance
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    // Initialize the ReviewDataProvider with Dio and SharedPreferences instances
    final ReviewDataProvider reviewDataProvider =
        ReviewDataProvider(dio, sharedPreferences);

    // Mock reviews for testing
    final List<Review> mockReviews = [
      Review(
          reviewId: '1',
          content: 'Great work!',
          rate: 5,
          jobId: '12',
          authorId: 3),
      Review(
          reviewId: '2',
          content: 'Needs improvement',
          rate: 3,
          jobId: '12',
          authorId: 3),
    ];

    // Create a ReviewLoadedState with the mock reviews
    final reviewLoadedState = ReviewLoadedState(mockReviews);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ReviewBloc>(
          create: (context) =>
              ReviewBloc(ConcreteReviewRepository(reviewDataProvider)),
          child: ReviewsPage(jobId: '123'),
        ),
      ),
    );

    // Verify if the app bar title is rendered
    expect(find.text('Reviews'), findsOneWidget);

    // Verify if CircularProgressIndicator is rendered initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Dispatch the ReviewLoadedState to the ReviewBloc
    BlocProvider.of<ReviewBloc>(tester.element(find.byType(ReviewsPage)))
        .add(reviewLoadedState as ReviewEvent);

    // Wait for the state to rebuild
    await tester.pump();

    // Verify if CircularProgressIndicator is not rendered after state update
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify if review contents and ratings are rendered
    expect(find.text('Great work!'), findsOneWidget);
    expect(find.text('Needs improvement'), findsOneWidget);
    expect(find.text('Rating: 5'), findsOneWidget);
    expect(find.text('Rating: 3'), findsOneWidget);
  });
}
