import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilefrontend/auth/presentation/view/login_page.dart';
import 'package:mobilefrontend/job/presentation/view/user_jobs.dart';
import 'package:mobilefrontend/user/application/bloc/user_bloc.dart';
import 'package:mobilefrontend/user/application/bloc/user_event.dart';
import 'package:mobilefrontend/user/application/bloc/user_state.dart';
import 'package:mobilefrontend/user/infrastructure/data_provider/user_data_provider.dart';
import 'package:mobilefrontend/user/domain/model/update_user_model.dart';
import 'package:mobilefrontend/user/domain/model/user_model.dart';
import 'package:mobilefrontend/user/infrastructure/repostory/user_repo.dart';
import 'package:mobilefrontend/user/presentation/view/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProfileBloc _userProfileBloc;
  late UpdateUserDto updatedData;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final UserDataProvider userDataProvider =
        UserDataProvider(Dio(), sharedPreferences);
    final UserRepository userRepository =
        ConcreteUserRepository(userDataProvider);
    _userProfileBloc = UserProfileBloc(userRepository);
    _userProfileBloc.add(LoadUserProfile());
  }

  @override
  void dispose() {
    _userProfileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocProvider<UserProfileBloc>(
              create: (context) => _userProfileBloc,
              child: BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (context, state) {
                  if (state is UserProfileInitial ||
                      state is UserProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserProfileLoaded) {
                    final userProfile = state.userProfile;
                    updatedData = UpdateUserDto(
                      email: userProfile?.email ?? '',
                      username: userProfile?.username ?? '',
                      firstName: userProfile?.firstname ?? '',
                      lastName: userProfile?.lastname ?? '',
                    );
                    return _buildProfileContent(userProfile);
                  } else if (state is UserProfileError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else {
                    return const Text('Unknown state');
                  }
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(UserProfile? userProfile) {
    if (userProfile == null) {
      return Center(child: Text('User Profile is null'));
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[900],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange[800],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProfile.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${userProfile.firstname} ${userProfile.lastname}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            userProfile.email,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 20,
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text(
                                  'Are you sure you want to delete your profile?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _userProfileBloc.add(DeleteUserProfile());
                                    GoRouter.of(context).go('/login');
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[900],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Include the UserEditButton widget
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[800], // Set the background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(initialData: updatedData),
              ),
            ).then((value) {
              if (value != null) {
                // Handle returned data here if needed
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit,
                color: Colors.black,
                size: 18,
              ),
              SizedBox(width: 5),
              Text(
                'Edit profile',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
