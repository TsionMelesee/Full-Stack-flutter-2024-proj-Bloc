import 'package:equatable/equatable.dart';
import 'package:mobilefrontend/user/domain/model/update_user_model.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  const LoadUserProfile();
}

class UpdateUserProfile extends UserProfileEvent {
  final UpdateUserDto updateDto;

  const UpdateUserProfile(this.updateDto);

  @override
  List<Object?> get props => [updateDto];
}

class DeleteUserProfile extends UserProfileEvent {
  const DeleteUserProfile();
}

class LoadAllUsers extends UserProfileEvent {}

class DeleteUserProfileByUserId extends UserProfileEvent {
  final int userId;

  const DeleteUserProfileByUserId(this.userId);

  @override
  List<Object?> get props => [userId];
}
