import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';
import 'package:gvm_flutter/src/widgets/unauthorized_access.dart';

class SalesHome extends StatefulWidget {
  const SalesHome({super.key});

  @override
  _SalesHomeState createState() => _SalesHomeState();
}

class _SalesHomeState extends State<SalesHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).salesHomeTitle),
      ),
      body: AuthGuard(
        permissions: [
          AppPermissions.saleBrowse,
          AppPermissions.deliveryBrowse,
          AppPermissions.customerBrowse,
        ],
        allPermissions: false,
        fallback: const UnauthorizedAccess(
          showBackButton: false,
        ),
        child: Text(AppLocalizations.of(context).salesHomeTitle),
      ),
    );
  }
}
