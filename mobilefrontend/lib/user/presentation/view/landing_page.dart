import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Set background color here
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Increased space here
                    Text(
                      'Welcome to Job Finder!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                      textAlign: TextAlign.center,
                    ), // Increased space here
                    Text(
                      'Discover your dream job today :)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orangeAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30), // Increased space here
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        FeatureCard(
                          iconData: Icons.work,
                          title: 'Jobs',
                          onTap: () {
                            // Implement feature navigation
                          },
                        ),
                        FeatureCard(
                          iconData: Icons.message,
                          title: 'Messages',
                          onTap: () {
                            // Implement feature navigation
                          },
                        ),
                        FeatureCard(
                          iconData: Icons.account_balance_wallet,
                          title: 'Salary',
                          onTap: () {
                            // Implement feature navigation
                          },
                        ),
                        FeatureCard(
                          iconData: Icons.location_on,
                          title: 'Locations',
                          onTap: () {
                            // Implement feature navigation
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/login');
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(Colors.orange[800]!),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Let\'s Get Started',
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              GoRouter.of(context).go('/adminlogin');
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
                    text: "Are you an admin? ",
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function()? onTap;

  const FeatureCard({
    required this.iconData,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.grey[800],
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                size: 40,
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
