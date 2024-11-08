import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/app.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

class AuthGuard extends StatefulWidget {
  final List<String> permissions;
  final bool allPermissions;
  final Widget child;
  final Widget? fallback;
  final bool maintainSpace;

  const AuthGuard(
      {super.key,
      required this.permissions,
      required this.child,
      this.fallback,
      this.maintainSpace = false,
      this.allPermissions = true});

  static bool checkPermissions(
    List<String> permissions, {
    bool allPermissions = true,
    bool showFeedback = true,
  }) {
    final currentUser = AuthManager.instance.currentUser;

    // Check if user is logged in
    if (currentUser == null) {
      if (showFeedback) {
        _showFeedback();
      }
      return false;
    }

    bool hasPermission;
    if (allPermissions) {
      // Check if user has all required permissions
      hasPermission = permissions
          .every((permission) => currentUser.permissions.contains(permission));
    } else {
      // Check if user has any of the required permissions
      hasPermission = permissions
          .any((permission) => currentUser.permissions.contains(permission));
    }

    if (!hasPermission && showFeedback) {
      _showFeedback();
    }

    return hasPermission;
  }

  static void _showFeedback() {
    final messenger = snackbarKey.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        width: 64,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, color: Colors.white, size: 16),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  State<AuthGuard> createState() => _PermissionGuardState();
}

class _PermissionGuardState extends State<AuthGuard> {
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  void _checkPermissions() {
    final currentUser = AuthManager.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    if (widget.allPermissions) {
      final hasAllPermissions = widget.permissions
          .every((permission) => currentUser.permissions.contains(permission));
      setState(() {
        _hasPermission = hasAllPermissions;
      });
    }

    final hasAnyPermissions = widget.permissions
        .any((permission) => currentUser.permissions.contains(permission));
    setState(() {
      _hasPermission = hasAnyPermissions;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return widget.fallback ??
          (widget.maintainSpace
              ? SizedBox(
                  width: widget.child.key != null
                      ? widget.child.key as double
                      : null,
                  height: widget.child.key != null
                      ? widget.child.key as double
                      : null,
                )
              : const SizedBox.shrink());
    }

    return widget.child;
  }
}
