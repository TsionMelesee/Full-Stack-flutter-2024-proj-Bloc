import 'package:equatable/equatable.dart';

class UpdateUserDto {
  final String firstName;
  final String lastName;
  final String? username;
  final String email;

  UpdateUserDto({
    this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props =>
      [username, email, firstName, lastName]; // Update props
  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
      };
}
