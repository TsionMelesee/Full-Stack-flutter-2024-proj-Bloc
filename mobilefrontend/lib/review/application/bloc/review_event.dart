import 'package:equatable/equatable.dart';
import 'package:mobilefrontend/review/domain/model/review_model.dart';
import 'package:mobilefrontend/review/domain/model/update_review_model.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class CreateReviewEvent extends ReviewEvent {
  final String jobId;
  final Review review;

  const CreateReviewEvent({required this.jobId, required this.review});

  @override
  List<Object> get props => [jobId, review];
}

class UpdateReviewEvent extends ReviewEvent {
  final UpdateReviewDto updateReviewDto;

  const UpdateReviewEvent(this.updateReviewDto);

  @override
  List<Object> get props => [updateReviewDto];
}

class DeleteReviewEvent extends ReviewEvent {
  final String reviewId;

  const DeleteReviewEvent(this.reviewId);

  @override
  List<Object> get props => [reviewId];
}

class GetReviewsByUserEvent extends ReviewEvent {}

class GetReviewsByJobIdEvent extends ReviewEvent {
  final String jobId;

  const GetReviewsByJobIdEvent(this.jobId);

  @override
  List<Object> get props => [jobId];
}
