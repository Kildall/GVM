import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/employees/employees/employee_read.dart';
import 'package:gvm_flutter/src/views/products/products/product_read.dart';
import 'package:gvm_flutter/src/views/sales/sales/sale_edit.dart';
import 'package:gvm_flutter/src/views/sales/sales/utils.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class SaleRead extends StatefulWidget {
  final int saleId;

  const SaleRead({
    super.key,
    required this.saleId,
  });

  @override
  _SaleReadState createState() => _SaleReadState();
}

class _SaleReadState extends State<SaleRead> {
  bool isLoading = true;
  Sale? sale;

  @override
  void initState() {
    super.initState();
    _loadSaleDetails();
  }

  Future<void> _loadSaleDetails() async {
    try {
      final response = await AuthManager.instance.apiService
          .get<Sale>('/api/sales/${widget.saleId}', fromJson: Sale.fromJson);

      if (response.data != null) {
        setState(() {
          sale = response.data;
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

  void _navigateToSaleEdit() {
    if (sale != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SaleEdit(sale: sale!)),
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

  void _navigateToCustomer(Customer customer) {
    // if (customer.id != null) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => CustomerRead(customerId: customer.id!),
    //   ));
    // }
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
          title: Text(AppLocalizations.of(context).saleDetailsTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (sale == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).saleDetailsTitle),
        ),
        body: Center(
          child: Text(AppLocalizations.of(context).noSalesFound),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).saleDetailsTitle),
        actions: [
          AuthGuard(
            permissions: [
              AppPermissions.saleEdit,
              AppPermissions.employeeBrowse,
              AppPermissions.customerBrowse,
              AppPermissions.productBrowse,
            ],
            allPermissions: true,
            fallback: null,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToSaleEdit,
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
              if (sale!.deliveries?.isNotEmpty ?? false) ...[
                const SizedBox(height: 24),
                _buildDeliveriesSection(),
              ],
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
                    Icons.shopping_cart,
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
                        '${AppLocalizations.of(context).sale} #${sale!.id}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        sale!.startDate?.toLocal().toString().split(' ')[0] ??
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: SalesUtils.getStatusColor(sale!.status!),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    SalesUtils.getStatusName(context, sale!.status!),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatisticItem(
                  icon: Icons.inventory_2,
                  label: AppLocalizations.of(context).products,
                  value: sale!.$productsCount?.toString() ?? '0',
                ),
                _StatisticItem(
                  icon: Icons.local_shipping,
                  label: AppLocalizations.of(context).deliveries,
                  value: sale!.$deliveriesCount?.toString() ?? '0',
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
              AppLocalizations.of(context).startDate,
              sale!.startDate?.toLocal().toString().split(' ')[0] ??
                  AppLocalizations.of(context).noDate,
            ),
            _buildDetailRow(
              AppLocalizations.of(context).lastUpdate,
              sale!.lastUpdateDate?.toLocal().toString().split(' ')[0] ??
                  AppLocalizations.of(context).noDate,
            ),
            _buildDetailRow(
              AppLocalizations.of(context).status,
              SalesUtils.getStatusName(context, sale!.status!),
              color: SalesUtils.getStatusColor(sale!.status!),
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
            if (sale!.customer != null)
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person_outline),
                ),
                title: Text(sale!.customer?.name ??
                    AppLocalizations.of(context).unnamedCustomer),
                subtitle: Text(AppLocalizations.of(context).customer),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  if (sale!.customer != null) {
                    AuthGuard.checkPermissions([AppPermissions.customerRead])
                        ? _navigateToCustomer(sale!.customer!)
                        : null;
                  }
                },
              ),
            if (sale!.employee != null)
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(sale!.employee?.name ??
                    AppLocalizations.of(context).unknownEmployee),
                subtitle: Text(AppLocalizations.of(context).employee),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  if (sale!.employee != null) {
                    AuthGuard.checkPermissions([AppPermissions.employeeRead])
                        ? _navigateToEmployee(sale!.employee!)
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
          AppLocalizations.of(context).soldProducts,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (sale!.products?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noProductsInSale,
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
              itemCount: sale!.products?.length ?? 0,
              itemBuilder: (context, index) {
                final productSale = sale!.products![index];
                final product = productSale.product;
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
                            '${AppLocalizations.of(context).quantity}: ${productSale.quantity}'),
                        if (product.brand != null) Text(product.brand!),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${(productSale.product?.price ?? 0).toStringAsFixed(2)}',
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

  Widget _buildDeliveriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).deliveries,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sale!.deliveries?.length ?? 0,
          itemBuilder: (context, index) {
            final delivery = sale!.deliveries![index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.local_shipping,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                    '${AppLocalizations.of(context).delivery} #${delivery.id}'),
                subtitle: Text(
                    delivery.startDate?.toLocal().toString().split(' ')[0] ??
                        AppLocalizations.of(context).noDate),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to delivery details if needed
                },
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
