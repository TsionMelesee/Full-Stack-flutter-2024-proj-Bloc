import 'package:dio/dio.dart';
import 'package:mobilefrontend/auth/domain/model/login_model.dart';
import 'package:mobilefrontend/user/domain/model/update_user_model.dart';
import 'package:mobilefrontend/user/domain/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  UserDataProvider(this.dio, this.sharedPreferences);

  Future<Map<String, dynamic>> _authenticatedRequest() async {
    final token = sharedPreferences.getString('token');
    final userId = sharedPreferences.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('Missing token or user ID in local storage.');
    }

    return {
      'userId': userId,
      'token': token,
    };
  }

  Future<UserProfile?> getProfile() async {
    try {
      final authData = await _authenticatedRequest();

      final response = await dio.get(
          'http://localhost:3000/users/profile/${authData['userId']}',
          options: Options(
              headers: {'Authorization': 'Bearer ${authData['token']}'}));

      if (response.statusCode == 200) {
        final data = response.data;
        return UserProfile(
          userId: authData['userId'],
          username: data['username'] as String,
          email: data['email'] as String,
          firstname: data['firstName'],
          lastname: data['lastName'],
        );
      } else {
        throw Exception(
            'Failed to fetch profile data. Status code: ${response.statusCode}');
      }
    } on DioError catch (error) {
      rethrow;
    } catch (error) {
      throw Exception('An error occurred while fetching profile data.');
    }
  }

  Future<void> updateProfile(UpdateUserDto dto) async {
    try {
      final authData = await _authenticatedRequest();

      final response = await dio.patch(
        'http://localhost:3000/users/${authData['userId']}',
        options:
            Options(headers: {'Authorization': 'Bearer ${authData['token']}'}),
        data: dto.toJson(),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully.');
      } else {
        throw Exception(
            'Failed to update profile. Status code: ${response.statusCode}');
      }
    } on DioError catch (error) {
      // Handle DioError
      print('Dio error occurred: $error');
      rethrow;
    } on Exception catch (error) {
      // Handle other exceptions
      print('Exception occurred: $error');
      rethrow;
    } catch (error) {
      // Catch all other errors
      print('Unexpected error occurred: $error');
      rethrow;
    }
  }

  Future<void> deleteProfile() async {
    try {
      final authData = await _authenticatedRequest();

      final response = await dio.delete(
        'http://localhost:3000/users/${authData['userId']}',
        options: Options(
          headers: {'Authorization': 'Bearer ${authData['token']}'},
        ),
      );

      if (response.statusCode == 200) {
        await sharedPreferences.clear();
        print('Profile deleted successfully.');
      } else {
        throw Exception(
            'Failed to delete profile. Status code: ${response.statusCode}');
      }
    } on DioError catch (error) {
      print('DioError occurred while deleting profile:');
      print(error);
      rethrow;
    } catch (error, stackTrace) {
      print('Error occurred while deleting profile: $error');
      print(stackTrace);
      throw Exception('An error occurred while deleting profile: $error');
    }
  }

  Future<List<UserProfile>> getAllUsers() async {
    try {
      final authData = await _authenticatedRequest();

      final response = await dio.get(
        'http://localhost:3000/users',
        options: Options(
          headers: {'Authorization': 'Bearer ${authData['token']}'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> userData = response.data;
        List<UserProfile> profiles = [];
        for (var data in userData) {
          profiles.add(
            UserProfile(
              userId: data['userId'],
              username: data['username'] as String,
              email: data['email'] as String,
              firstname: data['firstName'] as String,
              lastname: data['lastName'] as String,
            ),
          );
        }
        return profiles;
      } else {
        throw Exception(
            'Failed to fetch profile data. Status code: ${response.statusCode}');
      }
    } on DioError catch (error) {
      // Handle DioError or remove this try-catch block if you want to propagate DioError.
      rethrow;
    } catch (error) {
      throw Exception('An error occurred while fetching profile data.');
    }
  }

  Future<void> deleteProfileByUserId(int userId) async {
    try {
      final authData = await _authenticatedRequest();

      final response = await dio.delete(
        'http://localhost:3000/users/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer ${authData['token']}'},
        ),
      );

      if (response.statusCode == 200) {
        print('Profile for user $userId deleted successfully.');
      } else {
        throw Exception(
            'Failed to delete profile for user $userId. Status code: ${response.statusCode}');
      }
    } on DioError catch (error) {
      rethrow;
    } catch (error) {
      throw Exception(
          'An error occurred while deleting profile for user $userId.');
    }
  }
}
