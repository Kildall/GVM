import 'package:flutter/material.dart';

class LandingView extends StatelessWidget {
  static const routeName = '/';

  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Login'),
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () => Navigator.pushNamed(context, '/signup'),
            ),
          ],
        ),
      ),
    );
  }
}