import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobilefrontend/auth/domain/model/registration_model.dart';

class AuthRegDataProvider {
  Future<Map<String, dynamic>> registerUser(RegistrationData user) async {
    try {
      final response = await http.post(
          Uri.parse('http://localhost:3000/auth/signup'),
          body: json.encode(user.toJson()),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Registration failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow; // Rethrow the exception
    }
  }
}
