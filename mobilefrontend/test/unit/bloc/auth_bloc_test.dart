import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/auth/application/bloc/auth_bloc.dart';
import 'package:mobilefrontend/auth/application/bloc/auth_event.dart';
import 'package:mobilefrontend/auth/application/bloc/auth_state.dart';
import 'package:mobilefrontend/auth/infrastructure/repository/registration_repo.dart';
import 'package:mobilefrontend/auth/domain/model/registration_model.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRegRepository extends Mock implements AuthRegRepository {}

void main() {
  late AuthRegBloc authRegBloc;
  late MockAuthRegRepository mockAuthRegRepository;

  setUp(() {
    mockAuthRegRepository = MockAuthRegRepository();
    authRegBloc = AuthRegBloc(authRepository: mockAuthRegRepository);
    registerFallbackValue(RegistrationData(
      email: '',
      password: '',
      username: '',
      firstName: '',
      lastName: '',
      role: Role.USER,
    ));
  });

  tearDown(() {
    authRegBloc.close();
  });

  group('AuthRegBloc', () {
    blocTest<AuthRegBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when RegisterEvent is added and registration succeeds',
      build: () {
        when(() => mockAuthRegRepository.register(any()))
            .thenAnswer((_) async => RegistrationData(
                  password: 'password',
                  email: 'test@example.com',
                  username: 'test_user',
                  firstName: 'Test',
                  lastName: 'User',
                  role: Role.USER,
                ));
        return authRegBloc;
      },
      act: (bloc) => bloc.add(RegisterEvent(
        email: 'test@example.com',
        password: 'password',
        username: 'test_user',
        firstName: 'Test',
        lastName: 'User',
      )),
      expect: () => [
        AuthLoading(),
        isA<AuthAuthenticated>(), // Use matcher instead of concrete instance
      ],
      verify: (_) {
        verify(() => mockAuthRegRepository.register(any())).called(1);
      },
    );

    blocTest<AuthRegBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when AdminRegisterEvent is added and registration succeeds',
      build: () {
        when(() => mockAuthRegRepository.register(any()))
            .thenAnswer((_) async => RegistrationData(
                  password: 'password',
                  email: 'admin@example.com',
                  username: 'admin_user',
                  firstName: 'Admin',
                  lastName: 'User',
                  role: Role.ADMIN,
                ));
        return authRegBloc;
      },
      act: (bloc) => bloc.add(AdminRegisterEvent(
        email: 'admin@example.com',
        password: 'password',
        username: 'admin_user',
        firstName: 'Admin',
        lastName: 'User',
      )),
      expect: () => [
        AuthLoading(),
        isA<AuthAuthenticated>(), // Use matcher instead of concrete instance
      ],
      verify: (_) {
        verify(() => mockAuthRegRepository.register(any())).called(1);
      },
    );

    // Add more bloc tests for other events as needed
  });
}
