import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/products/purchases/purchase_read.dart';
import 'package:gvm_flutter/src/views/products/suppliers/supplier_edit.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class SupplierRead extends StatefulWidget {
  final int supplierId;

  const SupplierRead({
    super.key,
    required this.supplierId,
  });

  @override
  _SupplierReadState createState() => _SupplierReadState();
}

class _SupplierReadState extends State<SupplierRead> {
  bool isLoading = true;
  late Supplier? supplier;

  @override
  void initState() {
    super.initState();
    _loadSupplierDetails();
  }

  Future<void> _loadSupplierDetails() async {
    try {
      final response = await AuthManager.instance.apiService.get<Supplier>(
          '/api/suppliers/${widget.supplierId}',
          fromJson: Supplier.fromJson);

      if (response.data != null) {
        setState(() {
          supplier = response.data!;
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

  void _navigateToSupplierEdit() {
    if (supplier != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SupplierEdit(supplier: supplier!)),
      );
    }
  }

  void _navigateToPurchase(Purchase purchase) {
    if (purchase.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PurchaseRead(purchaseId: purchase.id!),
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
            .supplierDetailsTitle(supplier!.name ?? '')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: AuthGuard.checkPermissions(
              [
                AppPermissions.supplierEdit,
                AppPermissions.purchaseBrowse,
              ],
              allPermissions: true,
            )
                ? _navigateToSupplierEdit
                : null,
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
                    _buildHeaderSection(),
                    const SizedBox(height: 24),
                    _buildDetailsSection(),
                    const SizedBox(height: 24),
                    _buildPurchasesSection(),
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
                    Icons.business,
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
                        supplier!.name ??
                            AppLocalizations.of(context).unnamedSupplier,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        supplier!.enabled == true
                            ? AppLocalizations.of(context).enabled
                            : AppLocalizations.of(context).disabled,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: supplier!.enabled == true
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.error,
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
                  icon: Icons.shopping_bag,
                  label: AppLocalizations.of(context).totalPurchases,
                  value: supplier!.$purchasesCount?.toString() ?? '0',
                ),
                if (supplier!.purchases != null &&
                    supplier!.purchases!.isNotEmpty)
                  _StatisticItem(
                    icon: Icons.calendar_today,
                    label: AppLocalizations.of(context).lastPurchase,
                    value: supplier!.purchases!.last.date
                            ?.toLocal()
                            .toString()
                            .split(' ')[0] ??
                        '-',
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
            _buildDetailRow(
              AppLocalizations.of(context).name,
              supplier!.name ?? AppLocalizations.of(context).unnamedSupplier,
            ),
            _buildDetailRow(
              AppLocalizations.of(context).status,
              supplier!.enabled == true
                  ? AppLocalizations.of(context).enabled
                  : AppLocalizations.of(context).disabled,
              color: supplier!.enabled == true
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.error,
            ),
            _buildDetailRow(
              AppLocalizations.of(context).purchaseCount,
              '${supplier!.$purchasesCount ?? 0}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchasesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).purchaseHistory,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (supplier!.purchases?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noPurchasesFound,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: supplier!.purchases?.length ?? 0,
            itemBuilder: (context, index) {
              final purchase = supplier!.purchases![index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.shopping_bag,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                      '${AppLocalizations.of(context).purchase} #${purchase.id.toString().padLeft(4, '0')}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(purchase.date?.toLocal().toString().split(' ')[0] ??
                          AppLocalizations.of(context).noDate),
                      if (purchase.$productsCount != null)
                        Text(
                            '${purchase.$productsCount} ${AppLocalizations.of(context).products}'),
                      if (purchase.description != null &&
                          purchase.description!.isNotEmpty)
                        Text(purchase.description!),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${purchase.amount?.toStringAsFixed(2) ?? '0.00'}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () =>
                      AuthGuard.checkPermissions([AppPermissions.purchaseRead])
                          ? _navigateToPurchase(purchase)
                          : null,
                ),
              );
            },
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
