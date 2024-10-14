import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/widgets/login/login_widget.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login';

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: LoginWidget(),
        ),
      ),
    );
  }
}