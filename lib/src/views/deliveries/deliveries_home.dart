import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/mixins/refresh_on_pop.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/delivery_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/delivery_read.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/utils.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';
import 'package:gvm_flutter/src/widgets/deliveries/deliveries_filters.dart';

class DeliveriesHome extends StatefulWidget {
  const DeliveriesHome({super.key});

  @override
  _DeliveriesHomeState createState() => _DeliveriesHomeState();
}

class _DeliveriesHomeState extends State<DeliveriesHome>
    with RouteAware, RefreshOnPopMixin {
  bool isLoading = true;
  List<Delivery> deliveries = [];
  String? searchQuery;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  DeliveryStatusEnum? selectedStatus;
  DriverStatusEnum? selectedDriverStatus;

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  @override
  Future<void> refresh() async {
    await _loadDeliveries();
  }

  Future<void> _loadDeliveries() async {
    try {
      final user = AuthManager.instance.currentUser;
      if (user == null || user.employeeId == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      final deliveriesResponse = await AuthManager.instance.apiService
          .get<GetEmployeeDeliveriesResponse>(
              '/api/deliveries/employee/${user.employeeId}',
              fromJson: GetEmployeeDeliveriesResponse.fromJson);

      setState(() {
        isLoading = false;
        deliveries = deliveriesResponse.data?.deliveries ?? [];
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).anErrorOccurred)));
      }
    }
  }

  void _navigateToDeliveryDetail(Delivery delivery) {
    if (delivery.id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DeliveryRead(deliveryId: delivery.id!),
      ));
    }
  }

  void _clearFilters() {
    setState(() {
      searchQuery = null;
      selectedStartDate = null;
      selectedEndDate = null;
      selectedStatus = null;
      selectedDriverStatus = null;
    });
  }

  List<Delivery> get filteredDeliveries {
    return deliveries.where((delivery) {
      final matchesSearch = searchQuery == null ||
          searchQuery!.isEmpty ||
          delivery.employee?.name
                  ?.toLowerCase()
                  .contains(searchQuery!.toLowerCase()) ==
              true ||
          delivery.address?.street1
                  ?.toLowerCase()
                  .contains(searchQuery!.toLowerCase()) ==
              true;

      final matchesDateRange = (selectedStartDate == null ||
              delivery.startDate?.isAfter(selectedStartDate!) == true) &&
          (selectedEndDate == null ||
              delivery.startDate?.isBefore(
                      selectedEndDate!.add(const Duration(days: 1))) ==
                  true);

      final matchesStatus =
          selectedStatus == null || delivery.status == selectedStatus;

      final matchesDriverStatus = selectedDriverStatus == null ||
          delivery.driverStatus == selectedDriverStatus;

      return matchesSearch &&
          matchesDateRange &&
          matchesStatus &&
          matchesDriverStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).deliveries),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_off),
            onPressed: _clearFilters,
            tooltip: AppLocalizations.of(context).clearFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          DeliveriesFilters(
            searchQuery: searchQuery,
            selectedStartDate: selectedStartDate,
            selectedEndDate: selectedEndDate,
            selectedStatus: selectedStatus,
            selectedDriverStatus: selectedDriverStatus,
            onSearchChanged: (value) => setState(() => searchQuery = value),
            onStartDateChanged: (value) =>
                setState(() => selectedStartDate = value),
            onEndDateChanged: (value) =>
                setState(() => selectedEndDate = value),
            onStatusChanged: (value) => setState(() => selectedStatus = value),
            onDriverStatusChanged: (value) =>
                setState(() => selectedDriverStatus = value),
            onClearFilters: _clearFilters,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : deliveries.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).noDeliveriesFound,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredDeliveries.length,
                        itemBuilder: (context, index) {
                          final delivery = filteredDeliveries[index];
                          return _DeliveryListItem(
                            delivery: delivery,
                            onTap: () => AuthGuard.checkPermissions(
                                    [AppPermissions.deliveryRead])
                                ? _navigateToDeliveryDetail(delivery)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryListItem extends StatelessWidget {
  final Delivery delivery;
  final VoidCallback onTap;

  const _DeliveryListItem({
    required this.delivery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context).delivery} #${delivery.id.toString().padLeft(4, '0')}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (delivery.startDate != null)
                          Text(
                            delivery.startDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                  _DeliveryStatusChip(status: delivery.status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        delivery.employee?.name != null
                            ? Text(
                                delivery.employee!.name!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            : Text(
                                AppLocalizations.of(context).noDriver,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                        const SizedBox(width: 8),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            delivery.driverStatus != null
                                ? DriverUtils.getStatusName(
                                    context, delivery.driverStatus!)
                                : AppLocalizations.of(context).noStatus,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (delivery.address?.street1 != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        delivery.address!.street1!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
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

    return Chip(
      label: Text(
        DeliveriesUtils.getStatusName(context, status!),
        style: TextStyle(color: DeliveriesUtils.getStatusColor(status!)),
      ),
      backgroundColor: DeliveriesUtils.getStatusColor(status!).withOpacity(0.2),
      side: BorderSide(
        color: DeliveriesUtils.getStatusColor(status!),
      ),
    );
  }
}
