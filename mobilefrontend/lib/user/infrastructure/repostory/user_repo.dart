import 'package:mobilefrontend/user/infrastructure/data_provider/user_data_provider.dart';
import 'package:mobilefrontend/user/domain/model/update_user_model.dart';
import 'package:mobilefrontend/user/domain/model/user_model.dart';

abstract class UserRepository {
  Future<UserProfile?> getProfile();
  Future<void> updateProfile(UpdateUserDto dto);
  Future<void> deleteProfile();
  Future<List<UserProfile>> getAllUsers();
  Future<void> deleteProfileByUserId(int userId); // New method declaration
}

class ConcreteUserRepository implements UserRepository {
  final UserDataProvider dataProvider;

  ConcreteUserRepository(this.dataProvider);

  @override
  Future<UserProfile?> getProfile() async {
    return dataProvider.getProfile();
  }

  @override
  Future<void> updateProfile(UpdateUserDto dto) async {
    return dataProvider.updateProfile(dto);
  }

  @override
  Future<void> deleteProfile() async {
    return dataProvider.deleteProfile();
  }

  @override
  Future<List<UserProfile>> getAllUsers() async {
    return dataProvider.getAllUsers();
  }

  @override
  Future<void> deleteProfileByUserId(int userId) async {
    return dataProvider.deleteProfileByUserId(userId);
  }
}
