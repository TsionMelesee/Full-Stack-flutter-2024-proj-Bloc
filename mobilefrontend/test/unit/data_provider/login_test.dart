import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/auth/infrastructure/data_provider/login_data_providerl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobilefrontend/auth/infrastructure/repository/login_repo.dart';
import 'package:mobilefrontend/auth/domain/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthDataProvider extends Mock implements AuthDataProvider {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('AuthRepository', () {
    test('login - successful login', () async {
      // Arrange
      final mockDataProvider = MockAuthDataProvider();
      final mockSharedPreferences = MockSharedPreferences();
      final expectedToken = 'valid_token';
      final expectedUserId = 123;

      when(() =>
              mockDataProvider.login('test@example.com', 'password', Role.USER))
          .thenAnswer((_) async => {
                'token': expectedToken,
                'userId': expectedUserId,
              });

      when(() => mockSharedPreferences.setString('token', expectedToken))
          .thenAnswer((_) async => true);
      when(() => mockSharedPreferences.setInt('userId', expectedUserId))
          .thenAnswer((_) async => true);

      final repository =
          AuthRepository(mockDataProvider, mockSharedPreferences);

      // Act
      final loginData =
          await repository.login('test@example.com', 'password', Role.USER);

      // Assert
      expect(loginData.token, expectedToken);
      expect(loginData.id, expectedUserId);

      verify(() => mockSharedPreferences.setString('token', expectedToken))
          .called(1);
      verify(() => mockSharedPreferences.setInt('userId', expectedUserId))
          .called(1);
    });

    test('login - failed login', () async {
      // Arrange
      final mockDataProvider = MockAuthDataProvider();
      final mockSharedPreferences = MockSharedPreferences();
      final expectedErrorMessage = 'Invalid credentials';

      when(() =>
              mockDataProvider.login('test@example.com', 'password', Role.USER))
          .thenThrow(Exception(expectedErrorMessage));

      final repository =
          AuthRepository(mockDataProvider, mockSharedPreferences);

      // Act & Assert
      expect(
        () async =>
            await repository.login('test@example.com', 'password', Role.USER),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains(expectedErrorMessage)),
        ),
      );
    });
  });
}
