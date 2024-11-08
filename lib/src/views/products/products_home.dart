import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/products/products/products_browse.dart';
import 'package:gvm_flutter/src/views/products/purchases/purchases_browse.dart';
import 'package:gvm_flutter/src/views/products/suppliers/suppliers_browse.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';
import 'package:gvm_flutter/src/widgets/products/products_home_stats.dart';
import 'package:gvm_flutter/src/widgets/unauthorized_access.dart';

class ProductsHome extends StatefulWidget {
  const ProductsHome({super.key});

  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  bool isLoading = false;
  int productCount = 0;
  int lowStockCount = 0;

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            child: _NavigationCard(
                              title: AppLocalizations.of(context)
                                  .productManagement,
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
                            child: _NavigationCard(
                              title: AppLocalizations.of(context)
                                  .purchasesManagement,
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
                            child: _NavigationCard(
                              title: AppLocalizations.of(context).suppliers,
                              icon: Icons.store_outlined,
                              description: AppLocalizations.of(context)
                                  .suppliersDescription,
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

class _NavigationCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
