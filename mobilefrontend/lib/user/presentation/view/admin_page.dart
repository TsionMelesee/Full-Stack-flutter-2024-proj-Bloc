import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/user/application/bloc/user_bloc.dart';
import 'package:mobilefrontend/user/application/bloc/user_event.dart';
import 'package:mobilefrontend/user/application/bloc/user_state.dart';
import 'package:mobilefrontend/user/infrastructure/data_provider/user_data_provider.dart';
import 'package:mobilefrontend/user/domain/model/update_user_model.dart';
import 'package:mobilefrontend/user/domain/model/user_model.dart';
import 'package:mobilefrontend/user/infrastructure/repostory/user_repo.dart';
import 'package:mobilefrontend/user/presentation/view/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );
  }
}

class _ProfilePageState extends State<AdminProfilePage> {
  late UserProfileBloc _userProfileBloc;
  late UpdateUserDto updatedData; // Initialize updatedData
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = init();
  }

  Future<void> init() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final UserDataProvider userDataProvider = UserDataProvider(
        Dio(), sharedPreferences); // Create an instance of UserDataProvider
    final UserRepository userRepository =
        ConcreteUserRepository(userDataProvider);
    _userProfileBloc = UserProfileBloc(userRepository);
    _userProfileBloc.add(LoadAllUsers()); // Trigger initial profile load
  }

  @override
  void dispose() {
    _userProfileBloc.close(); // Close the bloc when the page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'User Profile List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(
          color: Colors
              .orange[800], // Change the color of the back arrow icon to orange
        ),
      ),
      body: FutureBuilder(
        future: _initFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocProvider(
              create: (context) => _userProfileBloc,
              child: BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (context, state) {
                  if (state is UserProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AllUsersLoaded) {
                    final users = state.users;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final userProfile = users[index];
                        return Card(
                          color: Colors.black87, // Black color with opacity
                          child: ListTile(
                            leading:
                                CustomIcon(), // Use the CustomIcon as leading
                            title: Text(
                              userProfile.username,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              userProfile.email,
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete,
                                  color:
                                      Colors.orange[800]), // Orange delete icon
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text(
                                          'Are you sure you want to delete this user?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _userProfileBloc.add(
                                                DeleteUserProfileByUserId(
                                                    userProfile
                                                        .userId)); // Pass userId to the event
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminProfilePage()));
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }, // Close onPressed
                            ), // Close trailing
                          ), // Close ListTile
                        ); // Close Card
                      }, // Close itemBuilder
                    ); // Close ListView.builder
                    // Close ListView.builder
                  } // Close else if
                  // Add a default return statement if needed
                  return Container(); // Placeholder container
                }, // Close builder function
              ), // Close BlocBuilder
            ); // Close BlocProvider
          } // Close if snapshot.connectionState
          // Add a default return statement if needed
          return Container(); // Placeholder container
        }, // Close builder function
      ), // Close FutureBuilder
    ); // Close Scaffold
  } // Close build method
} // Close _ProfilePageState class
