import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/domain/model/update_review_model.dart';
import 'package:mobilefrontend/review/infrastructure/data_provider/review_data_provider.dart';

abstract class ReviewRepository {
  Future<Review> createReview(String jobId, Review review);
  Future<void> deleteReview(String reviewId);
  Future<Review> updateReview(UpdateReviewDto dto);
  Future<List<Review>> getReviewsByUser();
  Future<List<Review>> getReviewsByJobId(String jobId);
}

class ConcreteReviewRepository implements ReviewRepository {
  final ReviewDataProvider reviewDataProvider;

  ConcreteReviewRepository(this.reviewDataProvider);

  @override
  Future<Review> createReview(String jobId, Review review) async {
    return await reviewDataProvider.createReview(jobId, review);
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    return await reviewDataProvider.deleteReview(reviewId);
  }

  @override
  Future<Review> updateReview(UpdateReviewDto dto) async {
    return await reviewDataProvider.updateReview(dto);
  }

  @override
  Future<List<Review>> getReviewsByUser() async {
    return await reviewDataProvider.getReviewsByUser();
  }

  @override
  Future<List<Review>> getReviewsByJobId(String jobId) async {
    return await reviewDataProvider.getReviewsByJobId(jobId);
  }
}
