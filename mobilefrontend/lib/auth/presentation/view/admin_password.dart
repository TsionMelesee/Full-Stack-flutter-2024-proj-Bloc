import 'package:flutter/material.dart';

class AdminPasswordDialog extends StatelessWidget {
  final String correctPassword;

  AdminPasswordDialog({required this.correctPassword});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    return AlertDialog(
      title: Text('Enter Admin Password'),
      content: TextField(
        controller: _passwordController,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_passwordController.text == correctPassword) {
              Navigator.of(context).pop(true); 
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Incorrect password. Please try again.'),
                ),
              );
            }
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
