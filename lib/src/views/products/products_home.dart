import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/products/products/products_browse.dart';
import 'package:gvm_flutter/src/views/products/purchases/purchases_browse.dart';
import 'package:gvm_flutter/src/views/products/suppliers/suppliers_browse.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';
import 'package:gvm_flutter/src/widgets/common/navigation_card.dart';
import 'package:gvm_flutter/src/widgets/products/products_home_stats.dart';
import 'package:gvm_flutter/src/widgets/unauthorized_access.dart';

class ProductsHome extends StatefulWidget {
  const ProductsHome({super.key});

  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  void _navigateToProducts() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ProductsBrowse(),
    ));
  }

  void _navigateToPurchases() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PurchasesBrowse(),
    ));
  }

  void _navigateToSuppliers() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SuppliersBrowse(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).productsHomeTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthGuard(
                permissions: [
                  AppPermissions.productBrowse,
                ],
                allPermissions: false,
                child: const ProductsHomeStats(),
              ),
              AuthGuard(
                permissions: [
                  AppPermissions.productBrowse,
                  AppPermissions.purchaseBrowse,
                  AppPermissions.supplierBrowse,
                ],
                allPermissions: false,
                fallback: const UnauthorizedAccess(
                  showBackButton: false,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).modules,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    AuthGuard(
                      permissions: [
                        AppPermissions.productBrowse,
                      ],
                      child: NavigationCard(
                        title: AppLocalizations.of(context).productManagement,
                        icon: Icons.inventory_2_outlined,
                        description: AppLocalizations.of(context)
                            .productManagementDescription,
                        onTap: _navigateToProducts,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AuthGuard(
                      permissions: [
                        AppPermissions.purchaseBrowse,
                      ],
                      child: NavigationCard(
                        title: AppLocalizations.of(context).purchasesManagement,
                        icon: Icons.warehouse_outlined,
                        description: AppLocalizations.of(context)
                            .purchasesManagementDescription,
                        onTap: _navigateToPurchases,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AuthGuard(
                      permissions: [
                        AppPermissions.supplierBrowse,
                      ],
                      child: NavigationCard(
                        title: AppLocalizations.of(context).suppliers,
                        icon: Icons.store_outlined,
                        description:
                            AppLocalizations.of(context).suppliersDescription,
                        onTap: _navigateToSuppliers,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
