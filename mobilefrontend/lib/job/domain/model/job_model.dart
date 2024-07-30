import 'package:meta/meta.dart';

enum UserType {
  EMPLOYEE,
  JOB_SEEKER,
}

class Job {
  final String? jobId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String title;
  final String description;
  final int? salary;
  final int createrId;
  final UserType userType;
  final String phonenumber; // Updated field name

  Job({
    this.jobId,
    this.createdAt,
    this.updatedAt,
    required this.title,
    required this.description,
    this.salary,
    required this.createrId,
    required this.userType,
    required this.phonenumber, // Updated field name
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobId: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      title: json['title'],
      phonenumber: json['phonenumber'], // Updated field name
      description: json['description'],
      salary: json['salary'],
      createrId: json['createrId'],
      userType: _parseUserType(json['userType']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': jobId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'title': title,
      'description': description,
      'salary': salary,
      'createrId': createrId,
      'userType': _userTypeToString(userType),
      'phonenumber': phonenumber, // Updated field name
    };
  }

  static UserType _parseUserType(String userTypeString) {
    return UserType.values.firstWhere(
      (type) => type.toString().split('.').last == userTypeString,
      orElse: () => UserType.EMPLOYEE,
    );
  }

  static String _userTypeToString(UserType userType) {
    return userType.toString().split('.').last;
  }
}
