import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeesHome extends StatefulWidget {
  const EmployeesHome({super.key});

  @override
  _EmployeesHomeState createState() => _EmployeesHomeState();
}

class _EmployeesHomeState extends State<EmployeesHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(AppLocalizations.of(context).employeesHomeTitle),
    );
  }
}
