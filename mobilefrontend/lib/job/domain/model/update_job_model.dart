import 'package:meta/meta.dart';

class UpdateJobDto {
  final String jobId; // Add jobId field
  final String title;
  final String description;

  final String phonenumber; // Updated field name
  final int? salary;

  UpdateJobDto({
    required this.jobId,
    required this.title,
    required this.description,
    this.salary,
    required this.phonenumber, // Updated field name
  });

  factory UpdateJobDto.fromJson(Map<String, dynamic> json) {
    return UpdateJobDto(
      jobId: json['jobId'],
      title: json['title'],
      description: json['description'],
      salary: json['salary'],
      phonenumber: json['phonenumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId, // Include jobId in the JSON data
      'title': title,
      'description': description,
      'salary': salary,

      'phonenumber': phonenumber, // Updated field name
    };
  }
}
