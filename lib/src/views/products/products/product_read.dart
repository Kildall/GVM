import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/mixins/refresh_on_pop.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/products/products/product_edit.dart';
import 'package:gvm_flutter/src/views/products/purchases/purchase_read.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';
import 'package:gvm_flutter/src/widgets/common/delete_button.dart';

class ProductRead extends StatefulWidget {
  final int productId;

  const ProductRead({
    super.key,
    required this.productId,
  });

  @override
  _ProductReadState createState() => _ProductReadState();
}

class _ProductReadState extends State<ProductRead>
    with RouteAware, RefreshOnPopMixin {
  bool isLoading = true;
  late Product? product;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  @override
  Future<void> refresh() async {
    await _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    try {
      final response = await AuthManager.instance.apiService.get<Product>(
          '/api/products/${widget.productId}',
          fromJson: Product.fromJson);

      if (response.success && response.data != null) {
        setState(() {
          product = response.data!;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).anErrorOccurred)));
      }
    }
  }

  Future<void> _deleteProduct() async {
    try {
      final response = await AuthManager.instance.apiService
          .delete('/api/products/${widget.productId}', fromJson: (json) => {});

      if (response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).removed)));
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).anErrorOccurred)));
      }
    }
  }

  void navigateToProductEdit() {
    if (product != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductEdit(product: product!)),
      );
    }
  }

  void navigateToSale(ProductSale sale) {}

  void navigateToPurchase(PurchaseProduct purchase) {
    if (purchase.purchaseId != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PurchaseRead(purchaseId: purchase.purchaseId!),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).loading),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .productDetailsTitle(product!.name ?? '')),
        actions: [
          AuthGuard(
            permissions: [
              AppPermissions.productEdit,
              AppPermissions.purchaseBrowse,
              AppPermissions.saleBrowse
            ],
            allPermissions: true,
            fallback: null,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: navigateToProductEdit,
                ),
                AuthGuard(
                  permissions: [AppPermissions.productDelete],
                  child: DeleteButton(
                    onDelete: _deleteProduct,
                    itemName: product?.name ??
                        AppLocalizations.of(context).unnamedProduct,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeaderSection(),
                    const SizedBox(height: 24),
                    buildInventorySection(),
                    const SizedBox(height: 24),
                    buildSalesSection(),
                    const SizedBox(height: 24),
                    buildPurchasesSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildHeaderSection() {
    final bool isLowStock = (product!.quantity ?? 0) < 10;
    final bool isOutOfStock = (product!.quantity ?? 0) == 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  radius: 30,
                  child: Icon(
                    Icons.inventory_2,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product!.name ??
                            AppLocalizations.of(context).unnamedProduct,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (product!.brand != null)
                        Text(
                          product!.brand!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  product!.enabled ?? true ? Icons.check_circle : Icons.cancel,
                  color: (product!.enabled ?? true)
                      ? Colors.green
                      : Theme.of(context).colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatisticItem(
                  icon: Icons.shopping_cart,
                  label: AppLocalizations.of(context).sales,
                  value: (product!.$salesCount ?? 0).toString(),
                ),
                _StatisticItem(
                  icon: Icons.shopping_bag,
                  label: AppLocalizations.of(context).purchases,
                  value: (product!.$purchasesCount ?? 0).toString(),
                ),
                _StatisticItem(
                  icon: Icons.inventory_2,
                  label: AppLocalizations.of(context).stock,
                  value: (product!.quantity ?? 0).toString(),
                  color: isOutOfStock
                      ? Colors.red
                      : isLowStock
                          ? Colors.orange
                          : Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInventorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).inventoryDetails,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            buildDetailRow(
              AppLocalizations.of(context).price,
              '\$${product!.price?.toStringAsFixed(2) ?? '0.00'}',
            ),
            buildDetailRow(
              AppLocalizations.of(context).quantity,
              '${product!.quantity ?? 0}',
              color: getStockColor(),
            ),
            if (product!.measure != null)
              buildDetailRow(
                AppLocalizations.of(context).measure,
                '${product!.measure} ml',
              ),
          ],
        ),
      ),
    );
  }

  Color getStockColor() {
    final quantity = product!.quantity ?? 0;
    if (quantity == 0) return Colors.red;
    if (quantity < 10) return Colors.orange;
    return Colors.green;
  }

  Widget buildSalesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).sales,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (product!.sales?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noSalesRecorded,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          Container(
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: const ScrollPhysics(),
              itemCount: product!.sales?.length ?? 0,
              itemBuilder: (context, index) {
                final sale = product!.sales![index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.shopping_cart),
                    ),
                    title: Text(
                        '${AppLocalizations.of(context).sale} #${sale.saleId.toString().padLeft(4, '0')}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sale.sale?.startDate?.toString() ?? ''),
                        Text(
                            '${AppLocalizations.of(context).quantity}: ${sale.quantity}'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        AuthGuard.checkPermissions([AppPermissions.saleRead])
                            ? navigateToSale(sale)
                            : null,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget buildPurchasesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).purchases,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (product!.purchases?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noPurchasesRecorded,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          Container(
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              physics: const ScrollPhysics(),
              itemCount: product!.purchases?.length ?? 0,
              itemBuilder: (context, index) {
                final purchase = product!.purchases![index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.shopping_bag),
                    ),
                    title: Text(
                        '${AppLocalizations.of(context).purchase} #${purchase.purchaseId.toString().padLeft(4, '0')}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(purchase.purchase?.date?.toString() ?? ''),
                        Text(
                            '${AppLocalizations.of(context).quantity}: ${purchase.quantity}'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => AuthGuard.checkPermissions(
                            [AppPermissions.purchaseRead])
                        ? navigateToPurchase(purchase)
                        : null,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatisticItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _StatisticItem({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color ?? Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
