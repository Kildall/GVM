import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/employees/employees/employee_read.dart';
import 'package:gvm_flutter/src/views/sales/customers/addresses/address_read.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/delivery_edit.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/utils.dart';
import 'package:gvm_flutter/src/views/sales/sales/sale_read.dart';
import 'package:gvm_flutter/src/views/sales/sales/utils.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class DeliveryRead extends StatefulWidget {
  final int deliveryId;

  const DeliveryRead({
    super.key,
    required this.deliveryId,
  });

  @override
  _DeliveryReadState createState() => _DeliveryReadState();
}

class _DeliveryReadState extends State<DeliveryRead> {
  bool isLoading = true;
  Delivery? delivery;

  @override
  void initState() {
    super.initState();
    _loadDeliveryDetails();
  }

  Future<void> _loadDeliveryDetails() async {
    try {
      final response = await AuthManager.instance.apiService.get<Delivery>(
          '/api/deliveries/${widget.deliveryId}',
          fromJson: Delivery.fromJson);

      setState(() {
        delivery = response.data;
        isLoading = false;
      });
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

  void _navigateToEmployee(Employee employee) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EmployeeRead(employee: employee),
    ));
  }

  void _navigateToDeliveryEdit() {
    if (delivery != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DeliveryEdit(delivery: delivery!),
      ));
    }
  }

  void _navigateToSale(int saleId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SaleRead(saleId: saleId),
    ));
  }

  void _navigateToAddress(int addressId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddressRead(addressId: addressId),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).deliveryDetails),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (delivery == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).deliveryDetails),
        ),
        body: Center(
          child: Text(AppLocalizations.of(context).noDeliveriesFound),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).deliveryDetails),
        actions: [
          AuthGuard(
            permissions: [
              AppPermissions.deliveryEdit,
              AppPermissions.employeeBrowse,
            ],
            allPermissions: true,
            fallback: null,
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _navigateToDeliveryEdit,
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
              _buildDriverSection(),
              const SizedBox(height: 24),
              _buildAddressSection(),
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
                    Icons.local_shipping,
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
                        '${AppLocalizations.of(context).delivery} #${delivery!.id.toString().padLeft(4, '0')}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        delivery!.startDate
                                ?.toLocal()
                                .toString()
                                .split(' ')[0] ??
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
                _DeliveryStatusChip(status: delivery!.status),
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
              delivery!.startDate?.toLocal().toString().split(' ')[0] ??
                  AppLocalizations.of(context).noDate,
            ),
            _buildDetailRow(
              AppLocalizations.of(context).lastUpdate,
              delivery!.lastUpdateDate?.toLocal().toString().split(' ')[0] ??
                  AppLocalizations.of(context).noDate,
            ),
            _buildDetailRow(
              AppLocalizations.of(context).deliveryStatus,
              SalesUtils.getStatusName(context, delivery!.sale!.status!),
            ),
            _buildDetailRow(
              AppLocalizations.of(context).driverStatus,
              delivery!.driverStatus != null
                  ? DriverUtils.getStatusName(context, delivery!.driverStatus!)
                  : AppLocalizations.of(context).noStatus,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverSection() {
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
            if (delivery!.employee != null)
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(delivery!.employee?.name ??
                    AppLocalizations.of(context).unknownEmployee),
                subtitle: Text(AppLocalizations.of(context).employee),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  if (delivery!.employee != null) {
                    AuthGuard.checkPermissions([AppPermissions.employeeRead])
                        ? _navigateToEmployee(delivery!.employee!)
                        : null;
                  }
                },
              )
            else
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person_off),
                ),
                title: Text(AppLocalizations.of(context).noDriver),
                subtitle: Text(AppLocalizations.of(context).employee),
              ),
            if (delivery!.sale != null)
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.business),
                ),
                title: Text(
                    '${AppLocalizations.of(context).sale} #${delivery!.sale?.id.toString().padLeft(4, '0')}'),
                subtitle: Text(AppLocalizations.of(context).sale),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  if (delivery!.sale != null) {
                    AuthGuard.checkPermissions([AppPermissions.saleRead])
                        ? _navigateToSale(delivery!.sale!.id!)
                        : null;
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
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
            if (delivery!.address != null)
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.location_on),
                ),
                title: Text(
                  delivery!.address!.street1 ??
                      AppLocalizations.of(context).noStreet,
                ),
                subtitle: Text(
                  [
                    delivery!.address!.city,
                    delivery!.address!.state,
                    delivery!.address!.postalCode,
                  ].where((item) => item != null && item.isNotEmpty).join(', '),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  if (delivery!.address != null) {
                    AuthGuard.checkPermissions([AppPermissions.addressRead])
                        ? _navigateToAddress(delivery!.address!.id!)
                        : null;
                  }
                },
              )
            else
              Text(AppLocalizations.of(context).noAddress),
          ],
        ),
      ),
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

class _DeliveryStatusChip extends StatelessWidget {
  final DeliveryStatusEnum? status;

  const _DeliveryStatusChip({this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: DeliveriesUtils.getStatusColor(status!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        DeliveriesUtils.getStatusName(context, status!),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
