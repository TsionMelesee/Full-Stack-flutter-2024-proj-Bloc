import 'package:equatable/equatable.dart';
import 'package:mobilefrontend/user/domain/model/user_model.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfile userProfile;

  const UserProfileLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class UserProfileUpdateSuccess extends UserProfileState {
  const UserProfileUpdateSuccess();
}

class UserProfileUpdateFailure extends UserProfileState {
  final String error;

  const UserProfileUpdateFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class UserProfileDeleteSuccess extends UserProfileState {
  const UserProfileDeleteSuccess();
}

class UserProfileDeleteFailure extends UserProfileState {
  final String error;

  const UserProfileDeleteFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class UserProfileError extends UserProfileState {
  final String error;

  const UserProfileError(this.error);

  @override
  List<Object?> get props => [error];
}

class AllUsersLoading extends UserProfileState {}

class AllUsersLoaded extends UserProfileState {
  final List<UserProfile> users;

  const AllUsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class AllUsersLoadFailure extends UserProfileState {
  final String error;

  const AllUsersLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AllUserProfileLoaded extends UserProfileState {
  final List<UserProfile> users;

  const AllUserProfileLoaded(this.users);

  @override
  List<Object?> get props => [users];
}
