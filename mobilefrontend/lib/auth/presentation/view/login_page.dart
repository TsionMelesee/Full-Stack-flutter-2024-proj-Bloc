import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilefrontend/auth/application/bloc/login_bloc.dart';
import 'package:mobilefrontend/auth/application/bloc/login_event.dart';
import 'package:mobilefrontend/auth/application/bloc/login_state.dart';
import 'package:mobilefrontend/auth/infrastructure/data_provider/login_data_providerl.dart';
import 'package:mobilefrontend/auth/domain/model/login_model.dart';
import 'package:mobilefrontend/auth/infrastructure/repository/login_repo.dart';
import 'package:mobilefrontend/job/presentation/view/job_seeker_jobs_page.dart';
import 'package:mobilefrontend/job/presentation/view/user_jobs.dart';
import 'package:mobilefrontend/review/presentation/view/user_review_page.dart';
import 'package:mobilefrontend/user/presentation/view/tab.dart';
import 'package:mobilefrontend/user/presentation/view/user.dart';
import 'package:mobilefrontend/user/presentation/view/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final sharedPreferences = snapshot.data!;
          return BlocProvider(
            create: (context) => LoginBloc(
              AuthRepository(
                AuthDataProvider(Dio()), // Initialize with Dio instance
                sharedPreferences, // Use SharedPreferences instance from FutureBuilder
              ),
            ),
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  GoRouter.of(context).go('/employer');
                } else if (state is LoginError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: LoginForm(
                emailController: _emailController,
                passwordController: _passwordController,
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Customicon(),
                const SizedBox(height: 50),
                _inputField("Email", emailController),
                const SizedBox(height: 20),
                _inputField("Password", passwordController, isPassword: true),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<LoginBloc>(context).add(
                      LoginRequested(
                        email: emailController.text,
                        password: passwordController.text,
                        role: Role.USER,
                      ),
                    );
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Sign in",
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
                const SizedBox(height: 20),
                extraText(context),
                const SizedBox(height: 20),
                TextDivider(),
                const SizedBox(height: 20),
                socialLoginRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.grey),
    );

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }
}

class Customicon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 120),
    );
  }
}

class TextDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: Colors.grey[600], // Darker divider
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Or continue with',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: Colors.grey[600], // Darker divider
          ),
        ),
      ],
    );
  }
}

class socialLoginRow extends StatelessWidget {
  const socialLoginRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SquareTile(imagePath: 'assets/google.png'),
        const SizedBox(width: 25),
        SquareTile(imagePath: 'assets/apple.png'),
      ],
    );
  }
}

class SquareTile extends StatelessWidget {
  final String imagePath;

  const SquareTile({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(imagePath),
    );
  }
}

Widget extraText(BuildContext context) {
  return GestureDetector(
    onTap: () {
      GoRouter.of(context).go('/registration');
    },
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: "Don't have an account? ",
          ),
          TextSpan(
            text: "Register now!",
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ),
  );
}
