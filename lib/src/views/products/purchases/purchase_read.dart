import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/employees/employees/employee_read.dart';
import 'package:gvm_flutter/src/views/products/products/product_read.dart';
import 'package:gvm_flutter/src/views/products/purchases/purchase_edit.dart';
import 'package:gvm_flutter/src/views/products/suppliers/supplier_read.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class PurchaseRead extends StatefulWidget {
  final int purchaseId;

  const PurchaseRead({
    super.key,
    required this.purchaseId,
  });

  @override
  _PurchaseReadState createState() => _PurchaseReadState();
}

class _PurchaseReadState extends State<PurchaseRead> {
  bool isLoading = true;
  Purchase? purchase;

  @override
  void initState() {
    super.initState();
    _loadPurchaseDetails();
  }

  Future<void> _loadPurchaseDetails() async {
    try {
      final response = await AuthManager.instance.apiService.get<Purchase>(
          '/api/purchases/${widget.purchaseId}',
          fromJson: Purchase.fromJson);

      if (response.data != null) {
        setState(() {
          purchase = response.data;
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

  void _navigateToPurchaseEdit() {
    if (purchase != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PurchaseEdit(purchase: purchase!)),
      );
    }
  }

  void _navigateToProduct(Product product) {
    if (product.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductRead(productId: product.id!),
      ));
    }
  }

  void _navigateToSupplier(Supplier supplier) {
    if (supplier.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SupplierRead(supplierId: supplier.id!),
      ));
    }
  }

  void _navigateToEmployee(Employee employee) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EmployeeRead(employee: employee),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).purchaseDetailsTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (purchase == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).purchaseDetailsTitle),
        ),
        body: Center(
          child: Text(AppLocalizations.of(context).noPurchasesFound),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).purchaseDetailsTitle),
        actions: [
          AuthGuard(
            permissions: [
              AppPermissions.purchaseEdit,
              AppPermissions.employeeBrowse,
              AppPermissions.supplierBrowse,
              AppPermissions.productBrowse,
            ],
            allPermissions: true,
            fallback: null,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToPurchaseEdit,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 24),
              _buildDetailsSection(),
              const SizedBox(height: 24),
              _buildParticipantsSection(),
              const SizedBox(height: 24),
              _buildProductsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
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
                    Icons.shopping_bag,
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
                        '${AppLocalizations.of(context).purchase} #${purchase!.id}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        purchase!.date?.toLocal().toString().split(' ')[0] ??
                            AppLocalizations.of(context).noDate,
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
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatisticItem(
                  icon: Icons.attach_money,
                  label: AppLocalizations.of(context).totalAmount,
                  value: purchase!.amount?.toStringAsFixed(2) ?? '0.00',
                ),
                _StatisticItem(
                  icon: Icons.inventory_2,
                  label: AppLocalizations.of(context).products,
                  value: purchase!.$productsCount?.toString() ?? '0',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).details,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (purchase!.description != null &&
                purchase!.description!.isNotEmpty)
              _buildDetailRow(
                AppLocalizations.of(context).description,
                purchase!.description!,
              ),
            _buildDetailRow(
              AppLocalizations.of(context).date,
              purchase!.date?.toLocal().toString().split(' ')[0] ??
                  AppLocalizations.of(context).noDate,
            ),
            _buildDetailRow(
              AppLocalizations.of(context).amount,
              '\$${purchase!.amount?.toStringAsFixed(2) ?? '0.00'}',
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).participants,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (purchase!.supplier != null)
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.business),
                ),
                title: Text(purchase!.supplier?.name ??
                    AppLocalizations.of(context).unknownSupplier),
                subtitle: Text(AppLocalizations.of(context).supplier),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  if (purchase!.supplier != null) {
                    AuthGuard.checkPermissions([AppPermissions.supplierRead])
                        ? _navigateToSupplier(purchase!.supplier!)
                        : null;
                  }
                },
              ),
            if (purchase!.employee != null)
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(purchase!.employee?.name ??
                    AppLocalizations.of(context).unknownEmployee),
                subtitle: Text(AppLocalizations.of(context).employee),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  if (purchase!.employee != null) {
                    AuthGuard.checkPermissions([AppPermissions.employeeRead])
                        ? _navigateToEmployee(purchase!.employee!)
                        : null;
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).purchasedProducts,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (purchase!.products?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noProductsInPurchase,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: purchase!.products?.length ?? 0,
              itemBuilder: (context, index) {
                final purchaseProduct = purchase!.products![index];
                final product = purchaseProduct.product;
                if (product == null) return const SizedBox.shrink();

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.inventory_2),
                    ),
                    title: Text(product.name ??
                        AppLocalizations.of(context).unnamedProduct),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${AppLocalizations.of(context).quantity}: ${purchaseProduct.quantity}'),
                        if (product.brand != null) Text(product.brand!),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${(purchaseProduct.product?.price ?? 0).toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () =>
                        AuthGuard.checkPermissions([AppPermissions.productRead])
                            ? _navigateToProduct(product)
                            : null,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
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

  const _StatisticItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
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
