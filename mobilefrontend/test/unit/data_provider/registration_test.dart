import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/auth/infrastructure/data_provider/registration_data_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobilefrontend/auth/infrastructure/repository/registration_repo.dart';
import 'package:mobilefrontend/auth/domain/model/registration_model.dart';

class MockRegDataProvider extends Mock implements AuthRegDataProvider {}

void main() {
  group('AuthRegRepository', () {
    test('register - successful registration', () async {
      // Arrange
      final mockDataProvider = MockRegDataProvider();
      final expectedResponse = {
        'email': 'test@example.com',
        'password': 'password',
        'username': 'testuser',
        'firstName': 'Test',
        'lastName': 'User',
        'role': 'USER',
      }; // Mocked successful registration response

      final repository = AuthRegRepository(dataProvider: mockDataProvider);

      // Act
      final registrationData = RegistrationData(
        email: 'test@example.com',
        password: 'password',
        username: 'testuser',
        firstName: 'Test',
        lastName: 'User',
        role: Role.USER,
      );
      when(() => mockDataProvider.registerUser(registrationData))
          .thenAnswer((_) async => expectedResponse);

      final response = await repository.register(registrationData);

      // Assert
      expect(response.email, 'test@example.com');
      expect(response.password, 'password');
      expect(response.username, 'testuser');
      expect(response.firstName, 'Test');
      expect(response.lastName, 'User');
      expect(response.role, Role.USER);
    });

    test('register - failed registration', () async {
      // Arrange
      final mockDataProvider = MockRegDataProvider();
      final expectedErrorMessage = 'User registration failed';

      final repository = AuthRegRepository(dataProvider: mockDataProvider);

      // Act & Assert
      final registrationData = RegistrationData(
        email: 'test@example.com',
        password: 'password',
        username: 'testuser',
        firstName: 'Test',
        lastName: 'User',
        role: Role.USER,
      );
      when(() => mockDataProvider.registerUser(registrationData))
          .thenThrow(Exception(expectedErrorMessage));

      expect(
        () async => await repository.register(registrationData),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains(expectedErrorMessage))),
      );
    });
  });
}
