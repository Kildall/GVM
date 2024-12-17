import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/mixins/refresh_on_pop.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/sales/customers/addresses/address_read.dart';
import 'package:gvm_flutter/src/views/sales/customers/customer_edit.dart';
import 'package:gvm_flutter/src/views/sales/sales/sale_read.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class CustomerRead extends StatefulWidget {
  final int customerId;

  const CustomerRead({
    super.key,
    required this.customerId,
  });

  @override
  _CustomerReadState createState() => _CustomerReadState();
}

class _CustomerReadState extends State<CustomerRead>
    with RouteAware, RefreshOnPopMixin {
  bool isLoading = true;
  Customer? customer;

  @override
  void initState() {
    super.initState();
    _loadCustomerDetails();
  }

  @override
  Future<void> refresh() async {
    await _loadCustomerDetails();
  }

  Future<void> _loadCustomerDetails() async {
    try {
      final response = await AuthManager.instance.apiService.get<Customer>(
          '/api/customers/${widget.customerId}',
          fromJson: Customer.fromJson);

      if (response.data != null) {
        setState(() {
          customer = response.data;
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

  void _navigateToCustomerEdit() {
    if (customer != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerEdit(customer: customer!)),
      );
    }
  }

  void _navigateToSale(Sale sale) {
    if (sale.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SaleRead(saleId: sale.id!),
      ));
    }
  }

  void _navigateToAddress(Address address) {
    if (address.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddressRead(addressId: address.id!),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).customerDetailsTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (customer == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).customerDetailsTitle),
        ),
        body: Center(
          child: Text(AppLocalizations.of(context).noCustomerFound),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).customerDetailsTitle),
        actions: [
          AuthGuard(
            permissions: [AppPermissions.customerEdit],
            allPermissions: true,
            fallback: null,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToCustomerEdit,
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
              _buildAddressesSection(),
              const SizedBox(height: 24),
              _buildSalesSection(),
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
                    Icons.person,
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
                        customer!.name ??
                            AppLocalizations.of(context).unnamedCustomer,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (customer!.phone != null)
                        Text(
                          customer!.phone!,
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
                    color: customer!.enabled == true
                        ? Colors.green
                        : Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    customer!.enabled == true
                        ? AppLocalizations.of(context).enabled
                        : AppLocalizations.of(context).disabled,
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
                  icon: Icons.location_on,
                  label: AppLocalizations.of(context).addresses,
                  value: customer!.$addressesCount?.toString() ?? '0',
                ),
                _StatisticItem(
                  icon: Icons.shopping_cart,
                  label: AppLocalizations.of(context).sales,
                  value: customer!.$salesCount?.toString() ?? '0',
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
              AppLocalizations.of(context).registrationDate,
              customer!.registrationDate?.toLocal().toString().split(' ')[0] ??
                  AppLocalizations.of(context).noDate,
            ),
            _buildDetailRow(
              AppLocalizations.of(context).status,
              customer!.enabled == true
                  ? AppLocalizations.of(context).enabled
                  : AppLocalizations.of(context).disabled,
              color: customer!.enabled == true
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).addresses,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (customer!.addresses?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noAddressesFound,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customer!.addresses?.length ?? 0,
            itemBuilder: (context, index) {
              final address = customer!.addresses![index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                      address.street1 ?? AppLocalizations.of(context).noStreet),
                  subtitle: Text([
                    address.city,
                    address.state,
                    address.postalCode,
                  ].where((item) => item != null).join(', ')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _navigateToAddress(address),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildSalesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).sales,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (customer!.sales?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noSalesFound,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customer!.sales?.length ?? 0,
            itemBuilder: (context, index) {
              final sale = customer!.sales![index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                      '${AppLocalizations.of(context).sale} #${sale.id.toString().padLeft(4, '0')}'),
                  subtitle: Text(
                      sale.startDate?.toLocal().toString().split(' ')[0] ??
                          AppLocalizations.of(context).noDate),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      AuthGuard.checkPermissions([AppPermissions.saleRead])
                          ? _navigateToSale(sale)
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
