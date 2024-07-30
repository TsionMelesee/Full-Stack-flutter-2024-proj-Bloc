import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/review/application/bloc/review_event.dart';
import 'package:mobilefrontend/review/application/bloc/review_state.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/infrastructure/repostory/review_repo.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc(this.reviewRepository) : super(ReviewInitialState()) {
    on<CreateReviewEvent>(_createReview);
    on<UpdateReviewEvent>(_updateReview);
    on<DeleteReviewEvent>(_deleteReview);
    on<GetReviewsByUserEvent>(_getReviewsByUser);
    on<GetReviewsByJobIdEvent>(_getReviewsByJobId);
  }

  Future<void> _createReview(
      CreateReviewEvent event, Emitter<ReviewState> emit) async {
    try {
      emit(ReviewLoadingState());
      final review =
          await reviewRepository.createReview(event.jobId, event.review);
      emit(ReviewSuccessState("Review created successfully!", review));
    } catch (error) {
      emit(ReviewErrorState(error.toString()));
    }
  }

  Future<void> _updateReview(
      UpdateReviewEvent event, Emitter<ReviewState> emit) async {
    try {
      emit(ReviewLoadingState());
      final updatedReview =
          await reviewRepository.updateReview(event.updateReviewDto);

      emit(ReviewSuccessState("Review updated successfully!", updatedReview));
    } catch (error) {
      emit(ReviewErrorState(error.toString()));
    }
  }

  Future<void> _deleteReview(
      DeleteReviewEvent event, Emitter<ReviewState> emit) async {
    try {
      emit(ReviewLoadingState());
      await reviewRepository.deleteReview(event.reviewId);

      // Fetch updated reviews after deleting the review
      final List<Review> updatedReviews =
          await reviewRepository.getReviewsByUser();

      emit(ReviewLoadedState(updatedReviews));
    } catch (error) {
      emit(ReviewErrorState(error.toString()));
    }
  }

  Future<void> _getReviewsByUser(
      GetReviewsByUserEvent event, Emitter<ReviewState> emit) async {
    try {
      emit(ReviewLoadingState());
      final reviews = await reviewRepository.getReviewsByUser();
      emit(ReviewLoadedState(reviews));
    } catch (error) {
      emit(ReviewErrorState(error.toString()));
    }
  }

  Future<void> _getReviewsByJobId(
      GetReviewsByJobIdEvent event, Emitter<ReviewState> emit) async {
    try {
      emit(ReviewLoadingState());
      final reviews = await reviewRepository.getReviewsByJobId(event.jobId);
      emit(ReviewLoadedState(reviews));
    } catch (error) {
      emit(ReviewErrorState(error.toString()));
    }
  }
}
