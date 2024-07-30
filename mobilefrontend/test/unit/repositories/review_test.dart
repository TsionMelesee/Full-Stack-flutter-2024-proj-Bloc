import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/review/infrastructure/repostory/review_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobilefrontend/review/infrastructure/data_provider/review_data_provider.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/domain/model/update_review_model.dart';

class MockReviewDataProvider extends Mock implements ReviewDataProvider {}

void main() {
  group('ConcreteReviewRepository', () {
    late MockReviewDataProvider mockReviewDataProvider;
    late ConcreteReviewRepository reviewRepository;

    setUp(() {
      mockReviewDataProvider = MockReviewDataProvider();
      reviewRepository = ConcreteReviewRepository(mockReviewDataProvider);
    });

    test('createReview - success', () async {
      // Arrange
      const jobId = '123';
      final review = Review(
        reviewId: '456',
        content: 'Great job!',
        rate: 5,
        jobId: jobId,
        authorId: 789,
      );
      when(() => mockReviewDataProvider.createReview(jobId, review))
          .thenAnswer((_) async => review);

      // Act
      final result = await reviewRepository.createReview(jobId, review);

      // Assert
      expect(result, review);
    });

    test('deleteReview - success', () async {
      // Arrange
      const reviewId = '456';
      when(() => mockReviewDataProvider.deleteReview(reviewId))
          .thenAnswer((_) async => null);

      // Act
      await reviewRepository.deleteReview(reviewId);

      // Assert
      verify(() => mockReviewDataProvider.deleteReview(reviewId)).called(1);
    });

    test('updateReview - success', () async {
      // Arrange
      final updateReviewDto = UpdateReviewDto(
        id: '456',
        content: 'Updated review',
        rate: 4,
      );
      when(() => mockReviewDataProvider.updateReview(updateReviewDto))
          .thenAnswer((_) async => Review.fromJson({
                'id': updateReviewDto.id,
                'content': updateReviewDto.content,
                'rate': updateReviewDto.rate,
                'jobId': '123',
                'authorId': 789,
              }));

      // Act
      final result = await reviewRepository.updateReview(updateReviewDto);

      // Assert
      expect(result, isA<Review>());
    });

    test('getReviewsByUser - success', () async {
      // Arrange
      final reviews = [
        Review(
          reviewId: '456',
          content: 'Great job!',
          rate: 5,
          jobId: '123',
          authorId: 789,
        ),
      ];
      when(() => mockReviewDataProvider.getReviewsByUser())
          .thenAnswer((_) async => reviews);

      // Act
      final result = await reviewRepository.getReviewsByUser();

      // Assert
      expect(result, reviews);
    });

    test('getReviewsByJobId - success', () async {
      // Arrange
      const jobId = '123';
      final reviews = [
        Review(
          reviewId: '456',
          content: 'Great job!',
          rate: 5,
          jobId: jobId,
          authorId: 789,
        ),
      ];
      when(() => mockReviewDataProvider.getReviewsByJobId(jobId))
          .thenAnswer((_) async => reviews);

      // Act
      final result = await reviewRepository.getReviewsByJobId(jobId);

      // Assert
      expect(result, reviews);
    });
  });
}
