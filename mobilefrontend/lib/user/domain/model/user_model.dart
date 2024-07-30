import 'package:equatable/equatable.dart';
import 'package:mobilefrontend/auth/domain/model/login_model.dart';

class UserProfile extends Equatable {
  final int userId; // Change id to userId
  final String firstname;
  final String lastname;
  final String username;
  final String email;

  final Role? userRole;

  UserProfile({
    required this.userId, // Change id to userId
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.userRole,
  });

  @override
  List<Object?> get props =>
      [userId, username, email, firstname, lastname, userRole]; // Update props
}
