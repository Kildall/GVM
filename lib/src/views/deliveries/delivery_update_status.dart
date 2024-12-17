import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';
import 'package:gvm_flutter/src/models/request/delivery_requests.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/sales/deliveries/utils.dart';

class DeliveryUpdateStatus extends StatefulWidget {
  final Delivery delivery;

  const DeliveryUpdateStatus({
    super.key,
    required this.delivery,
  });

  @override
  State<DeliveryUpdateStatus> createState() => _DeliveryUpdateStatusState();
}

class _DeliveryUpdateStatusState extends State<DeliveryUpdateStatus> {
  DriverStatusEnum? selectedStatus;
  bool isLoading = false;

  static const allowedTransitions = {
    DriverStatusEnum.PENDING_PICKUP: [
      DriverStatusEnum.PICKING_UP,
      DriverStatusEnum.CANCELLED,
    ],
    DriverStatusEnum.PICKING_UP: [
      DriverStatusEnum.IN_TRANSIT,
      DriverStatusEnum.CANCELLED,
    ],
    DriverStatusEnum.IN_TRANSIT: [
      DriverStatusEnum.TRYING_DELIVERY,
      DriverStatusEnum.CANCELLED,
    ],
    DriverStatusEnum.TRYING_DELIVERY: [
      DriverStatusEnum.DELIVERED,
      DriverStatusEnum.NOT_DELIVERED,
      DriverStatusEnum.CANCELLED,
    ],
    DriverStatusEnum.NOT_DELIVERED: [
      DriverStatusEnum.IN_RETURN,
      DriverStatusEnum.CANCELLED,
    ],
    DriverStatusEnum.IN_RETURN: [
      DriverStatusEnum.PENDING_PICKUP,
      DriverStatusEnum.CANCELLED,
    ],
    DriverStatusEnum.DELIVERED: <DriverStatusEnum>[],
    DriverStatusEnum.CANCELLED: <DriverStatusEnum>[],
  };

  @override
  void initState() {
    super.initState();
    // Only set the initial status if it's in the allowed transitions
    final allowedStatuses = _getAllowedStatuses();
    if (allowedStatuses.contains(widget.delivery.driverStatus)) {
      selectedStatus = widget.delivery.driverStatus;
    } else {
      selectedStatus = null; // Reset to null if current status isn't allowed
    }
  }

  List<DriverStatusEnum> _getAllowedStatuses() {
    if (widget.delivery.driverStatus == null) {
      return [DriverStatusEnum.PENDING_PICKUP];
    }
    return allowedTransitions[widget.delivery.driverStatus!] ?? [];
  }

  Future<void> _updateStatus() async {
    if (selectedStatus == null ||
        selectedStatus == widget.delivery.driverStatus) {
      return;
    }

    setState(() => isLoading = true);

    try {
      final request = UpdateDeliveryRequest(
        deliveryId: widget.delivery.id!,
        driverStatus: selectedStatus!,
      );

      final response = await AuthManager.instance.apiService.put(
        '/api/deliveries',
        fromJson: (json) => {},
        body: request.toJson(),
      );

      if (response.data != null && mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).anErrorOccurred)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allowedStatuses = _getAllowedStatuses();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).update),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).currentStatus,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DriverUtils.getStatusName(
                          context, widget.delivery.driverStatus),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).newStatus,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (allowedStatuses.isEmpty)
                      Text(
                        AppLocalizations.of(context).noTransitions,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      )
                    else
                      DropdownButtonFormField<DriverStatusEnum>(
                        value: selectedStatus,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context).selectStatus,
                        ),
                        items: allowedStatuses.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                                DriverUtils.getStatusName(context, status)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedStatus = value);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isLoading ||
                  selectedStatus == widget.delivery.driverStatus ||
                  selectedStatus == null
              ? null
              : _updateStatus,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(AppLocalizations.of(context).update),
        ),
      ),
    );
  }
}
