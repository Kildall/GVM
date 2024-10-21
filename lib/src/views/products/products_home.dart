import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsHome extends StatefulWidget {
  const ProductsHome({super.key});

  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(AppLocalizations.of(context).productsHomeTitle),
    );
  }
}
