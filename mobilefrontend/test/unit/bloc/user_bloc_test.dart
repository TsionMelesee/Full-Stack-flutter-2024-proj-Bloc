import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilefrontend/auth/domain/model/login_model.dart';
import 'package:mobilefrontend/user/application/bloc/user_bloc.dart';
import 'package:mobilefrontend/user/application/bloc/user_event.dart';
import 'package:mobilefrontend/user/application/bloc/user_state.dart';
import 'package:mobilefrontend/user/domain/model/update_user_model.dart';
import 'package:mobilefrontend/user/domain/model/user_model.dart';
import 'package:mobilefrontend/user/infrastructure/repostory/user_repo.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late UserProfileBloc userProfileBloc;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userProfileBloc = UserProfileBloc(mockUserRepository);
  });

  tearDown(() {
    userProfileBloc.close();
  });

  group('UserProfileBloc', () {
    final userProfile = UserProfile(
      userId: 1,
      username: 'john_doe',
      email: 'john@example.com',
      firstname: 'John',
      lastname: 'Doe',
      userRole: Role.USER,
    );

    blocTest<UserProfileBloc, UserProfileState>(
      'emits [UserProfileLoading, UserProfileLoaded] when LoadUserProfile is added and succeeds',
      build: () {
        when(() => mockUserRepository.getProfile())
            .thenAnswer((_) async => userProfile);
        return userProfileBloc;
      },
      act: (bloc) => bloc.add(LoadUserProfile()),
      expect: () => [
        UserProfileLoading(),
        UserProfileLoaded(userProfile),
      ],
      verify: (_) {
        verify(() => mockUserRepository.getProfile()).called(1);
      },
    );
    group('UserProfileBloc', () {
      final updateDto = UpdateUserDto(
        firstName: 'John',
        lastName: 'Doe',
        username: 'john_doe',
        email: 'john@example.com',
      );

      blocTest<UserProfileBloc, UserProfileState>(
        'emits [UserProfileLoading, UserProfileUpdateSuccess] when UpdateUserProfile is added and succeeds',
        build: () {
          when(() => mockUserRepository.updateProfile(updateDto)).thenAnswer(
              (_) async => null); // Assuming updateProfile() returns void
          return userProfileBloc;
        },
      );

      // Add more bloc tests for other events as needed
    });
  });
}
