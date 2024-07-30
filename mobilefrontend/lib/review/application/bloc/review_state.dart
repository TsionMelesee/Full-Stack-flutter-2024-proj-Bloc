import 'package:equatable/equatable.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewInitialState extends ReviewState {}

class ReviewLoadingState extends ReviewState {}

class ReviewLoadedState extends ReviewState {
  final List<Review> reviews;

  const ReviewLoadedState(this.reviews);

  @override
  List<Object> get props => [reviews];
}

class ReviewSuccessState extends ReviewState {
  final String message;
  final Review? review;

  const ReviewSuccessState(this.message, [this.review]);

  @override
  List<Object> get props => [message, review!];
}

class ReviewErrorState extends ReviewState {
  final String errorMessage;

  const ReviewErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
