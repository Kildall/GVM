import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/mixins/refresh_on_pop.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/sales/customers/customer_read.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/delivery_read.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class AddressRead extends StatefulWidget {
  final int addressId;

  const AddressRead({
    super.key,
    required this.addressId,
  });

  @override
  _AddressReadState createState() => _AddressReadState();
}

class _AddressReadState extends State<AddressRead>
    with RouteAware, RefreshOnPopMixin {
  bool isLoading = true;
  Address? address;

  @override
  void initState() {
    super.initState();
    _loadAddressDetails();
  }

  @override
  Future<void> refresh() async {
    await _loadAddressDetails();
  }

  Future<void> _loadAddressDetails() async {
    try {
      final response = await AuthManager.instance.apiService.get<Address>(
          '/api/addresses/${widget.addressId}',
          fromJson: Address.fromJson);

      if (response.data != null) {
        setState(() {
          address = response.data;
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

  void _navigateToCustomer() {
    if (address?.customer?.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CustomerRead(customerId: address!.customer!.id!),
      ));
    }
  }

  void _navigateToDelivery(Delivery delivery) {
    if (delivery.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DeliveryRead(deliveryId: delivery.id!),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).addressDetails),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (address == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).addressDetails),
        ),
        body: Center(
          child: Text(AppLocalizations.of(context).noAddressFound),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addressDetails),
        actions: [
          AuthGuard(
            permissions: [AppPermissions.addressEdit],
            allPermissions: true,
            fallback: null,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to address edit
              },
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
              _buildAddressDetailsSection(),
              const SizedBox(height: 24),
              _buildCustomerSection(),
              const SizedBox(height: 24),
              _buildDeliveriesSection(),
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
                    Icons.location_on,
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
                        address!.name ??
                            AppLocalizations.of(context).unknownType,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        address!.street1 ??
                            AppLocalizations.of(context).noStreet,
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
                    color: address!.enabled == true
                        ? Colors.green
                        : Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    address!.enabled == true
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
                  icon: Icons.local_shipping,
                  label: AppLocalizations.of(context).deliveries,
                  value: address!.$deliveriesCount?.toString() ?? '0',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).address,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (address!.street1 != null)
              _buildDetailRow(
                AppLocalizations.of(context).street,
                address!.street1!,
              ),
            if (address!.street2 != null)
              _buildDetailRow(
                AppLocalizations.of(context).secondaryStreet,
                address!.street2!,
              ),
            if (address!.city != null)
              _buildDetailRow(
                AppLocalizations.of(context).city,
                address!.city!,
              ),
            if (address!.state != null)
              _buildDetailRow(
                AppLocalizations.of(context).state,
                address!.state!,
              ),
            if (address!.postalCode != null)
              _buildDetailRow(
                AppLocalizations.of(context).postalCode,
                address!.postalCode!,
              ),
            if (address!.details != null)
              _buildDetailRow(
                AppLocalizations.of(context).details,
                address!.details!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection() {
    if (address?.customer == null) return const SizedBox.shrink();

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(address!.customer!.name ??
            AppLocalizations.of(context).unnamedCustomer),
        subtitle: address!.customer!.phone != null
            ? Text(address!.customer!.phone!)
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => AuthGuard.checkPermissions([AppPermissions.customerRead])
            ? _navigateToCustomer()
            : null,
      ),
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
        if (address!.deliveries?.isEmpty ?? true)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context).noDeliveriesFound,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: address!.deliveries?.length ?? 0,
            itemBuilder: (context, index) {
              final delivery = address!.deliveries![index];
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
                      '${AppLocalizations.of(context).delivery} #${delivery.id.toString().padLeft(4, '0')}'),
                  subtitle: Text(
                      delivery.startDate?.toLocal().toString().split(' ')[0] ??
                          AppLocalizations.of(context).noDate),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      AuthGuard.checkPermissions([AppPermissions.deliveryRead])
                          ? _navigateToDelivery(delivery)
                          : null,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
