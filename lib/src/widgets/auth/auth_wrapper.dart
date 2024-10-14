import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/services/api/auth_service.dart';
import 'package:gvm_flutter/src/views/login/login_view.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        if (authService.isAuthenticated) {
          return child;
        } else {
          return LoginView();
        }
      },
    );
  }
}