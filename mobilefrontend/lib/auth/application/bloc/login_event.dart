import 'package:equatable/equatable.dart';
import 'package:mobilefrontend/auth/domain/model/auth_model.dart';
import 'package:mobilefrontend/auth/domain/model/login_model.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;
  final Role role;

  LoginRequested(
      {required this.email, required this.password, required this.role});
}

class AdminLoginRequested extends LoginEvent {
  final String email;
  final String password;
  final Role role;

  AdminLoginRequested(
      {required this.email, required this.password, required this.role});
}

class LoginResponseReceived extends LoginEvent {
  final bool success;
  final String? message;
  final AuthLoginData? data;

  const LoginResponseReceived(this.success, this.message, this.data);

  @override
  List<Object?> get props => [success, message, data];
}

class LogoutRequested extends LoginEvent {}
