import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/auth/application/bloc/login_bloc.dart';
import 'package:mobilefrontend/auth/application/bloc/login_event.dart';
import 'package:mobilefrontend/auth/application/bloc/login_state.dart';
import 'package:mobilefrontend/auth/domain/model/auth_model.dart';
import 'package:mobilefrontend/auth/domain/model/login_model.dart';
import 'package:mobilefrontend/auth/infrastructure/repository/login_repo.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginBloc loginBloc;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(Role.USER);
    registerFallbackValue(Role.ADMIN);
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginBloc = LoginBloc(mockAuthRepository);
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc', () {
    final validLoginData = AuthLoginData(token: 'token', id: 1);

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] when LoginRequested is added and login succeeds',
      build: () {
        when(() => mockAuthRepository.login(any(), any(), any()))
            .thenAnswer((_) async => validLoginData);
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginRequested(
        email: 'test@example.com',
        password: 'password',
        role: Role.USER,
      )),
      expect: () => [
        LoginLoading(),
        LoginSuccess(validLoginData),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.login(any(), any(), any())).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] when AdminLoginRequested is added and login succeeds',
      build: () {
        when(() => mockAuthRepository.login(any(), any(), any()))
            .thenAnswer((_) async => validLoginData);
        return loginBloc;
      },
      act: (bloc) => bloc.add(AdminLoginRequested(
        email: 'admin@example.com',
        password: 'password',
        role: Role.ADMIN,
      )),
      expect: () => [
        LoginLoading(),
        LoginSuccess(validLoginData),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.login(any(), any(), any())).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginError] when LoginRequested is added and login fails',
      build: () {
        when(() => mockAuthRepository.login(any(), any(), any()))
            .thenThrow(Exception('Login failed'));
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginRequested(
        email: 'test@example.com',
        password: 'password',
        role: Role.USER,
      )),
      expect: () => [
        LoginLoading(),
        LoginError('Exception: Login failed'),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.login(any(), any(), any())).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginError] when AdminLoginRequested is added and login fails',
      build: () {
        when(() => mockAuthRepository.login(any(), any(), any()))
            .thenThrow(Exception('Login failed'));
        return loginBloc;
      },
      act: (bloc) => bloc.add(AdminLoginRequested(
        email: 'admin@example.com',
        password: 'password',
        role: Role.ADMIN,
      )),
      expect: () => [
        LoginLoading(),
        LoginError('Exception: Login failed'),
      ],
      verify: (_) {
        verify(() => mockAuthRepository.login(any(), any(), any())).called(1);
      },
    );
  });
}
