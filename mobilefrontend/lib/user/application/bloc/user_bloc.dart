import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/user/application/bloc/user_event.dart';
import 'package:mobilefrontend/user/application/bloc/user_state.dart';
import 'package:mobilefrontend/user/infrastructure/repostory/user_repo.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository userRepository;

  UserProfileBloc(this.userRepository) : super(UserProfileInitial()) {
    on<LoadUserProfile>((event, emit) async {
      try {
        emit(UserProfileLoading());
        final userProfile = await userRepository.getProfile();
        emit(UserProfileLoaded(userProfile!)); // Ensure userProfile is not null
      } catch (error) {
        emit(UserProfileError(error.toString()));
      }
    });
    on<LoadAllUsers>((event, emit) async {
      try {
        emit(UserProfileLoading());
        final users = await userRepository.getAllUsers();
        if (users.isNotEmpty) {
          emit(AllUsersLoaded(users));
        } else {
          emit(UserProfileError("No users found."));
        }
      } catch (error) {
        emit(UserProfileError(error.toString()));
      }
    });

    on<UpdateUserProfile>((event, emit) async {
      try {
        emit(UserProfileLoading());
        await userRepository.updateProfile(event.updateDto);
        // Reload user profile after update
        add(LoadUserProfile()); // Dispatch LoadUserProfile event
        emit(UserProfileUpdateSuccess());
      } catch (error) {
        emit(UserProfileUpdateFailure(error.toString()));
      }
    });

    on<DeleteUserProfile>((event, emit) async {
      try {
        emit(UserProfileLoading());
        await userRepository.deleteProfile();
        emit(UserProfileDeleteSuccess());
      } catch (error) {
        emit(UserProfileDeleteFailure(error.toString()));
      }
    });
    on<DeleteUserProfileByUserId>((event, emit) async {
      try {
        emit(UserProfileLoading());
        await userRepository.deleteProfileByUserId(
            event.userId); // Pass userId to the repository method
        emit(UserProfileDeleteSuccess());
      } catch (error) {
        emit(UserProfileDeleteFailure(error.toString()));
      }
    });
  }
}
