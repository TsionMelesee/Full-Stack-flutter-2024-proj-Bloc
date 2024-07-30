import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilefrontend/auth/application/bloc/login_bloc.dart';
import 'package:mobilefrontend/auth/application/bloc/login_event.dart';
import 'package:mobilefrontend/user/presentation/view/user_profile.dart';
import 'package:go_router/go_router.dart';

class UserAccount extends StatelessWidget {
  static const routeName = '/useraccount';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.grey[900],
          iconTheme: IconThemeData(color: Colors.orange),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                GoRouter.of(context).go('/login');
                context.read<LoginBloc>().add(LogoutRequested());
              },
            ),
          ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 320, // Adjust the height of the profile header
            child: ProfilePage(), // Display the profile header
          ),
          SizedBox(
            height: 16,
          ), // Add vertical space between profile header and tab bar
          Container(
            height: 2,
            color: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              // Wrap the tab bar section
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.5, // Limit the height of the tab bar section
                decoration: BoxDecoration(
                  color:
                      Colors.grey[900], // Background color of the tab bar area
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Adjust horizontal padding as needed
                  child:
                      CustomIcon(), // Display the tab bar below the profile header
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Navigate to the tab view
            GoRouter.of(context).go('/tab');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 8),
              // Wrap the Text widget with MouseRegion to change cursor to hand pointer
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  'Click Here See Your Jobs and Reviews',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey[800], // Dark background color
            borderRadius: BorderRadius.circular(60), // Circular shape
            border: Border.all(
              color: Colors.white, // White border
              width: 2, // Border width
            ),
          ),
          child: Center(
            child: Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Colors.grey[800], // Grey[800] background color for icon
                  ),
                  child: Icon(
                    Icons.list, // Job related icon
                    color: Colors.orange[800], // Orange icon color
                    size: 50,
                  ),
                ),
                Positioned.fill(
                  child: ClipOval(
                    child: Container(
                      padding: EdgeInsets.all(2), // Adjust border width
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // White border
                          width: 2, // Border width
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
