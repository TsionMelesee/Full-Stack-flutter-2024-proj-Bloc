import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobilefrontend/job/presentation/view/user_jobs.dart';
import 'package:mobilefrontend/review/presentation/view/user_review_page.dart';
import 'package:mobilefrontend/user/presentation/view/user_profile.dart';

class GetTabBar extends StatefulWidget {
  @override
  _GetTabBarState createState() => _GetTabBarState();
}

class _GetTabBarState extends State<GetTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            GoRouter.of(context).go('/user');
          },
        ),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(40), // Adjust the height of the tab bar
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.work, color: Colors.white)),
              Tab(icon: Icon(Icons.reviews, color: Colors.white)),
            ],
            indicator: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.orange, width: 3.0)),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UserJobsPage(),
          UserReviewsPage(),
        ],
      ),
    );
  }
}
