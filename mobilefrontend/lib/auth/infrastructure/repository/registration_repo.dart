import 'package:mobilefrontend/auth/infrastructure/data_provider/registration_data_provider.dart';
import 'package:mobilefrontend/auth/domain/model/registration_model.dart';

class AuthRegRepository {
  final AuthRegDataProvider _dataProvider;

  AuthRegRepository({required AuthRegDataProvider dataProvider})
      : _dataProvider = dataProvider;

  Future<RegistrationData> register(RegistrationData registrationData) async {
    try {
      final registeredDataJson =
          await _dataProvider.registerUser(registrationData);
      final registeredData = RegistrationData.fromJson(registeredDataJson);
      return registeredData;
    } catch (error) {
      throw Exception('Registration failed: $error');
    }
  }
}
