enum Role {
  ADMIN,
  USER,
}

class RegistrationData {
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;
  final Role role;

  RegistrationData({
    required this.email,
    required this.password,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'role': role.toString().split('.').last, // Convert enum to string
    };
  }

  static RegistrationData fromJson(Map<String, dynamic> registrationDataJson) {
  return RegistrationData(
    email: registrationDataJson['email'],
    password: registrationDataJson['password'],
    username: registrationDataJson['username'],
    firstName: registrationDataJson['firstName'],
    lastName: registrationDataJson['lastName'],
    role: registrationDataJson['role'] == 'ADMIN' ? Role.ADMIN : Role.USER,
  );

  }
}
