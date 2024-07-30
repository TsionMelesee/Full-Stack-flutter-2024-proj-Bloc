import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilefrontend/auth/application/bloc/login_bloc.dart';
import 'package:mobilefrontend/auth/infrastructure/data_provider/login_data_providerl.dart';
import 'package:mobilefrontend/auth/infrastructure/repository/login_repo.dart';
import 'package:mobilefrontend/auth/presentation/view/admin_login_page.dart';
import 'package:mobilefrontend/auth/presentation/view/admin_password.dart';
import 'package:mobilefrontend/auth/presentation/view/admin_registration_page.dart';
import 'package:mobilefrontend/auth/presentation/view/login_page.dart';
import 'package:mobilefrontend/auth/presentation/view/registration.dart';
import 'package:mobilefrontend/job/application/bloc/job_bloc.dart';
import 'package:mobilefrontend/job/infrastructure/data_provider/job_data_provider.dart';
import 'package:mobilefrontend/job/infrastructure/repostory/job_repostory.dart';
import 'package:mobilefrontend/job/presentation/view/employee_job.dart';
import 'package:mobilefrontend/job/presentation/view/job_create.dart';
import 'package:mobilefrontend/job/presentation/view/job_seeker_jobs_page.dart';
import 'package:mobilefrontend/job/presentation/view/user_jobs.dart';
import 'package:mobilefrontend/review/application/bloc/review_bloc.dart';
import 'package:mobilefrontend/review/infrastructure/data_provider/review_data_provider.dart';
import 'package:mobilefrontend/review/infrastructure/repostory/review_repo.dart';
import 'package:mobilefrontend/review/presentation/view/user_review_page.dart';
import 'package:mobilefrontend/user/infrastructure/data_provider/user_data_provider.dart';
import 'package:mobilefrontend/user/infrastructure/repostory/user_repo.dart';
import 'package:mobilefrontend/user/presentation/view/admin_page.dart';
import 'package:mobilefrontend/user/presentation/view/landing_page.dart';
import 'package:mobilefrontend/user/presentation/view/navigation.dart';
import 'package:mobilefrontend/user/presentation/view/tab.dart';
import 'package:mobilefrontend/user/presentation/view/user.dart';
import 'package:mobilefrontend/user/presentation/view/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = Dio(); // Instantiate Dio
  final sharedPreferences =
      await SharedPreferences.getInstance(); // Instantiate SharedPreferences

  final userDataProvider =
      UserDataProvider(dio, sharedPreferences); // Instantiate UserDataProvider
  final userRepository = ConcreteUserRepository(
      userDataProvider); // Instantiate ConcreteUserRepository
  final jobRepository = ConcreteJobRepository(
      JobDataProvider(dio, sharedPreferences)); // Instantiate JobRepository
  final authDataProvider =
      AuthDataProvider(dio); // Instantiate AuthDataProvider
  final authRepository = AuthRepository(
      authDataProvider, sharedPreferences); // Instantiate AuthRepository
  final reviewDataProvider = ReviewDataProvider(
      dio, sharedPreferences); // Instantiate ReviewDataProvider
  runApp(MyApp(
    authRepository: authRepository,
    jobRepository: jobRepository,
    reviewDataProvider: reviewDataProvider,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final JobRepository jobRepository;
  final ReviewDataProvider reviewDataProvider;

  MyApp({
    Key? key,
    required this.authRepository,
    required this.jobRepository,
    required this.reviewDataProvider,
  });

  final GoRouter _router = GoRouter(
    initialLocation: '/landing',
    routes: [
      GoRoute(
        path: '/adminregistration',
        builder: (context, state) => AdminRegistrationPage(),
      ),
      GoRoute(
        path: '/adminlogin',
        builder: (context, state) => AdminLoginPage(),
      ),
      GoRoute(
        path: '/adminpage',
        builder: (context, state) => AdminProfilePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfilePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/jobseekers',
        builder: (context, state) => MainLayout(child: JobSeekerJobsPage()),
      ),
      GoRoute(
        path: '/registration',
        builder: (context, state) => UserRegistrationPage(),
      ),
      GoRoute(
        path: '/userreview',
        builder: (context, state) => UserReviewsPage(),
      ),
      GoRoute(
        path: '/userjob',
        builder: (context, state) => UserJobsPage(),
      ),
      GoRoute(
        path: '/user',
        builder: (context, state) => MainLayout(child: UserAccount()),
      ),
      GoRoute(
        path: '/tab',
        builder: (context, state) => GetTabBar(),
      ),
      GoRoute(
        path: '/landing',
        builder: (context, state) => LandingPage(),
      ),
      GoRoute(
        path: '/createjob',
        builder: (context, state) => MainLayout(child: CreateJobPage()),
      ),
      GoRoute(
        path: '/employer',
        builder: (context, state) => MainLayout(child: EmployeeJobsPage()),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(child: Text(state.error.toString())),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(authRepository),
        ),
        BlocProvider<JobBloc>(
          create: (context) => JobBloc(jobRepository),
        ),
        BlocProvider<ReviewBloc>(
          create: (context) =>
              ReviewBloc(ConcreteReviewRepository(reviewDataProvider)),
        ),
      ],
      child: MaterialApp.router(
        title: 'JobHub',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig:
            _router, // Use `routerConfig` instead of `routeInformationParser` and `routerDelegate`
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
