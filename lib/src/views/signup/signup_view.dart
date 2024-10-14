import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  static const routeName = '/signup';

  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Center(child: Text('Signup form goes here')),
    );
  }
}