import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [email, password, username, firstName, lastName];
}

class AdminRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;

  const AdminRegisterEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [email, password, username, firstName, lastName];
}
