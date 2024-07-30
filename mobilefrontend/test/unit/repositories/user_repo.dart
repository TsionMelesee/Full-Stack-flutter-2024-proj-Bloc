import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/user/infrastructure/repostory/user_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobilefrontend/user/infrastructure/data_provider/user_data_provider.dart';
import 'package:mobilefrontend/user/domain/model/update_user_model.dart';
import 'package:mobilefrontend/user/domain/model/user_model.dart';

class MockUserDataProvider extends Mock implements UserDataProvider {}

void main() {
  group('ConcreteUserRepository', () {
    late MockUserDataProvider mockUserDataProvider;
    late ConcreteUserRepository userRepository;

    setUp(() {
      mockUserDataProvider = MockUserDataProvider();
      userRepository = ConcreteUserRepository(mockUserDataProvider);
    });

    test('getProfile - success', () async {
      // Arrange
      final userProfile = UserProfile(
        userId: 123,
        username: 'testuser',
        email: 'test@example.com',
        firstname: 'Test',
        lastname: 'User',
      );
      when(() => mockUserDataProvider.getProfile())
          .thenAnswer((_) async => userProfile);

      // Act
      final result = await userRepository.getProfile();

      // Assert
      expect(result, userProfile);
    });

    test('updateProfile - success', () async {
      // Arrange
      final updateUserDto = UpdateUserDto(
        email: 'test@example.com',
        username: 'testuser',
        firstName: 'Test',
        lastName: 'User',
      );
      when(() => mockUserDataProvider.updateProfile(updateUserDto))
          .thenAnswer((_) async => null);

      // Act
      await userRepository.updateProfile(updateUserDto);

      // Assert
      verify(() => mockUserDataProvider.updateProfile(updateUserDto)).called(1);
    });

    test('deleteProfile - success', () async {
      // Arrange
      when(() => mockUserDataProvider.deleteProfile())
          .thenAnswer((_) async => null);

      // Act
      await userRepository.deleteProfile();

      // Assert
      verify(() => mockUserDataProvider.deleteProfile()).called(1);
    });

    test('getAllUsers - success', () async {
      // Arrange
      final users = [
        UserProfile(
          userId: 123,
          username: 'testuser1',
          email: 'test1@example.com',
          firstname: 'Test1',
          lastname: 'User1',
        ),
        UserProfile(
          userId: 456,
          username: 'testuser2',
          email: 'test2@example.com',
          firstname: 'Test2',
          lastname: 'User2',
        ),
      ];
      when(() => mockUserDataProvider.getAllUsers())
          .thenAnswer((_) async => users);

      // Act
      final result = await userRepository.getAllUsers();

      // Assert
      expect(result, users);
    });

    test('deleteProfileByUserId - success', () async {
      // Arrange
      const userId = 123;
      when(() => mockUserDataProvider.deleteProfileByUserId(userId))
          .thenAnswer((_) async => null);

      // Act
      await userRepository.deleteProfileByUserId(userId);

      // Assert
      verify(() => mockUserDataProvider.deleteProfileByUserId(userId))
          .called(1);
    });
  });
}
