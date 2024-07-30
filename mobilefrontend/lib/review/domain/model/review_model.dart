import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String reviewId;
  final String content;
  final int rate;
  final String jobId;
  final int authorId;

  Review({
    required this.reviewId,
    required this.content,
    required this.rate,
    required this.jobId,
    required this.authorId,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        reviewId: json['id'],
        content: json['content'],
        rate: json['rate'],
        jobId: json['jobId'],
        authorId: json['authorId'],
      );

  Map<String, dynamic> toJson() => {
        'id': reviewId,
        'content': content,
        'rate': rate,
        'jobId': jobId,
        'authorId': authorId,
      };

  @override
  List<Object?> get props => [reviewId, content, rate, jobId, authorId];
}
