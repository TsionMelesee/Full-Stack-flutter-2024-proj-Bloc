enum Role {
  ADMIN,
  USER,
}

class LoginData {
  final String email;
  final String password;

  final Role role;

  LoginData({
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role.toString().split('.').last, // Convert enum to string
    };
  }

  static LoginData fromJson(Map<String, dynamic> LoginDataJson) {
    return LoginData(
      email: LoginDataJson['email'],
      password: LoginDataJson['password'],
      role: LoginDataJson['role'] == 'ADMIN' ? Role.ADMIN : Role.USER,
    );
  }
}
