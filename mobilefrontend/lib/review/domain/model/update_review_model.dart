import 'package:equatable/equatable.dart';

class UpdateReviewDto extends Equatable {
  final String id;
  final String content;
  final int rate;

  UpdateReviewDto({
    required this.id,
    required this.content,
    required this.rate,
  });

  factory UpdateReviewDto.fromJson(Map<String, dynamic> json) =>
      UpdateReviewDto(
        id: json['id'],
        content: json['content'],
        rate: json['rate'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'rate': rate,
      };

  @override
  List<Object?> get props => [id, content, rate];
}
