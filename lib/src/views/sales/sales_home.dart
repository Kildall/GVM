import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SalesHome extends StatefulWidget {
  const SalesHome({super.key});

  @override
  _SalesHomeState createState() => _SalesHomeState();
}

class _SalesHomeState extends State<SalesHome> {
  @override
  Widget build(BuildContext context) {
    return Text(AppLocalizations.of(context).salesHomeTitle);
  }
}
