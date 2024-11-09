import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/response/delivery_responses.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/services/auth/permissions.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/utils.dart';
import 'package:gvm_flutter/src/widgets/auth_guard.dart';

class DeliveriesBrowse extends StatefulWidget {
  const DeliveriesBrowse({super.key});

  @override
  _DeliveriesBrowseState createState() => _DeliveriesBrowseState();
}

class _DeliveriesBrowseState extends State<DeliveriesBrowse> {
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

  Future<void> _loadDeliveries() async {
    try {
      final deliveriesResponse = await AuthManager.instance.apiService
          .get<GetDeliveriesResponse>('/api/deliveries',
              fromJson: GetDeliveriesResponse.fromJson);

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
    // if (delivery.id != null) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => DeliveryRead(deliveryId: delivery.id!),
    //   ));
    // }
  }

  void _navigateToDeliveryAdd() {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => const DeliveryAdd(),
    // ));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).searchDeliveries,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectStartDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(selectedStartDate != null
                            ? AppLocalizations.of(context).fromDate(
                                selectedStartDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0])
                            : AppLocalizations.of(context).startDate),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectEndDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(selectedEndDate != null
                            ? AppLocalizations.of(context).toDate(
                                selectedEndDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0])
                            : AppLocalizations.of(context).endDate),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<DeliveryStatusEnum?>(
                        decoration: InputDecoration(
                          label: Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                            child: AutoSizeText(
                              AppLocalizations.of(context).deliveryStatus,
                              maxLines: 1,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        value: selectedStatus,
                        items: [
                          DropdownMenuItem<DeliveryStatusEnum?>(
                            value: null,
                            child: Text(AppLocalizations.of(context).all),
                          ),
                          ...DeliveryStatusEnum.values.map((status) {
                            return DropdownMenuItem<DeliveryStatusEnum?>(
                              value: status,
                              child: Text(
                                DeliveriesUtils.getStatusName(context, status),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedStatus = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<DriverStatusEnum?>(
                        decoration: InputDecoration(
                          label: Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                            child: AutoSizeText(
                              AppLocalizations.of(context).driverStatus,
                              maxLines: 1,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        value: selectedDriverStatus,
                        items: [
                          DropdownMenuItem<DriverStatusEnum?>(
                            value: null,
                            child: Text(AppLocalizations.of(context).all),
                          ),
                          ...DriverStatusEnum.values.map((status) {
                            return DropdownMenuItem<DriverStatusEnum?>(
                              value: status,
                              child: Text(
                                DriverUtils.getStatusName(context, status),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedDriverStatus = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
      floatingActionButton: AuthGuard(
        permissions: [
          AppPermissions.deliveryAdd,
          AppPermissions.employeeBrowse,
          AppPermissions.saleBrowse,
        ],
        allPermissions: true,
        fallback: null,
        child: FloatingActionButton(
          onPressed: _navigateToDeliveryAdd,
          child: const Icon(Icons.add),
        ),
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.local_shipping,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text('Delivery #${delivery.id}'),
            ),
            _DeliveryStatusChip(status: delivery.status),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (delivery.startDate != null)
              Text(delivery.startDate!.toLocal().toString().split(' ')[0]),
            if (delivery.employee?.name != null) Text(delivery.employee!.name!),
            if (delivery.address?.street1 != null)
              Text(
                delivery.address!.street1!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chevron_right),
            if (delivery.driverStatus != null)
              Text(
                delivery.driverStatus!.name,
                style: Theme.of(context).textTheme.labelSmall,
              ),
          ],
        ),
        onTap: onTap,
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
