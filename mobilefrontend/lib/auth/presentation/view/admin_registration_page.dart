import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilefrontend/auth/application/bloc/auth_bloc.dart';
import 'package:mobilefrontend/auth/application/bloc/auth_event.dart';
import 'package:mobilefrontend/auth/infrastructure/data_provider/registration_data_provider.dart';
import 'package:mobilefrontend/auth/infrastructure/repository/registration_repo.dart';

class AdminRegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.orange,
          ),
          onPressed: () {
            GoRouter.of(context).go('/adminlogin');
          },
        ),
      ),
      body: BlocProvider(
        create: (context) => AuthRegBloc(
            authRepository:
                AuthRegRepository(dataProvider: AuthRegDataProvider())),
        child: UserRegistrationForm(),
      ),
    );
  }
}

class UserRegistrationForm extends StatefulWidget {
  @override
  _UserRegistrationFormState createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfilePictureInput(),
                const SizedBox(height: 20),
                _inputField("Email", emailController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                }),
                const SizedBox(height: 20),
                _inputField("Username", usernameController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                }),
                const SizedBox(height: 20),
                _inputField("First Name", firstNameController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                }),
                const SizedBox(height: 20),
                _inputField("Last Name", lastNameController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                }),
                const SizedBox(height: 20),
                _inputField("Password", passwordController, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                }, isPassword: true),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<AuthRegBloc>(context)
                          .add(AdminRegisterEvent(
                        email: emailController.text,
                        password: passwordController.text,
                        username: usernameController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                      ));
                      // Navigate to admin login page after registration
                      GoRouter.of(context).go('/adminlogin');
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orange[800],
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      FormFieldValidator<String> validator,
      {bool isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );

    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
      validator: validator,
    );
  }
}

class ProfilePictureInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("assets/download.png"),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.orange[800],
            child: Icon(
              Icons.camera_alt,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
