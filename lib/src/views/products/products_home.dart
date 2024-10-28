import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/response/product_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/products/products/products_browse.dart';
import 'package:gvm_flutter/src/views/products/purchases/purchases_browse.dart';
import 'package:gvm_flutter/src/views/products/suppliers/suppliers_browse.dart';

class ProductsHome extends StatefulWidget {
  const ProductsHome({super.key});

  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  bool isLoading = true;
  int productCount = 0;
  int lowStockCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final productsResponse = await AuthManager.instance.apiService
          .get<GetProductsResponse>('/api/products',
              fromJson: GetProductsResponse.fromJson);

      final products = productsResponse.data?.products ?? [];
      final lowStock = products.where((p) => (p.quantity ?? 0) < 10).length;

      setState(() {
        isLoading = false;
        productCount = products.length;
        lowStockCount = lowStock;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error appropriately
    }
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).statistics,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatisticCard(
                            icon: Icons.inventory_2,
                            title: AppLocalizations.of(context).products,
                            value: productCount.toString(),
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatisticCard(
                            icon: Icons.warning,
                            title: AppLocalizations.of(context).lowStock,
                            value: lowStockCount.toString(),
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context).modules,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _NavigationCard(
                          title: AppLocalizations.of(context).productManagement,
                          icon: Icons.inventory_2_outlined,
                          description: AppLocalizations.of(context)
                              .productManagementDescription,
                          onTap: _navigateToProducts,
                        ),
                        const SizedBox(height: 16),
                        _NavigationCard(
                          title:
                              AppLocalizations.of(context).purchasesManagement,
                          icon: Icons.warehouse_outlined,
                          description: AppLocalizations.of(context)
                              .purchasesManagementDescription,
                          onTap: _navigateToPurchases,
                        ),
                        const SizedBox(height: 16),
                        _NavigationCard(
                          title: AppLocalizations.of(context).suppliers,
                          icon: Icons.store_outlined,
                          description:
                              AppLocalizations.of(context).suppliersDescription,
                          onTap: _navigateToSuppliers,
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

class _StatisticCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatisticCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
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
