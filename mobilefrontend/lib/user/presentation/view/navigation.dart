import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilefrontend/job/presentation/view/employee_job.dart';
import 'package:mobilefrontend/job/presentation/view/job_create.dart';
import 'package:mobilefrontend/job/presentation/view/job_seeker_jobs_page.dart';
import 'package:mobilefrontend/user/presentation/view/user.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _page = 0;

  final List<String> _routeNames = [
    '/employer',
    '/jobseekers',
    '/createjob',
    '/user',
  ];
  List<Widget> _pages = [
    EmployeeJobsPage(),
    JobSeekerJobsPage(),
    CreateJobPage(),
    UserAccount(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _page = index;
    });
    context.go(_routeNames[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[900]!, // Set background color here
        buttonBackgroundColor: Colors.orange,
        color: Colors.black, // Set icon color
        animationDuration: const Duration(milliseconds: 300),
        index: _page.clamp(0, 3),
        items: <Widget>[
          Icon(Icons.person, size: 26, color: Colors.white),
          Icon(Icons.work, size: 26, color: Colors.white),
          Icon(Icons.add, size: 26, color: Colors.white),
          Icon(Icons.account_circle, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _pages[_page],
    );
  }
}
