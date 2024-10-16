import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

class AuthListener extends StatelessWidget {
  final Widget authenticated;
  final Widget unAuthenticated;

  /// Listens and returns [authenticated] or [unAuthenticated] widgets
  /// according to [AuthManager.instance.isAuthenticated].
  const AuthListener({
    super.key,
    required this.authenticated,
    required this.unAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthManager.instance.authStateAsStream,
      builder: (context, AsyncSnapshot<bool> authStateAsync) {
        if (authStateAsync.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        return (authStateAsync.data ?? false) ? authenticated : unAuthenticated;
      },
    );
  }
}
