import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/delivery_status_enum.dart';
import 'package:gvm_flutter/src/models/driver_status_enum.dart';

class DeliveriesUtils {
  static Color getStatusColor(DeliveryStatusEnum status) {
    switch (status) {
      case DeliveryStatusEnum.ASSIGNED:
        return Colors.blue;
      case DeliveryStatusEnum.IN_PROGRESS:
        return Colors.green;
      case DeliveryStatusEnum.IN_TRANSIT:
        return Colors.green;
      case DeliveryStatusEnum.CANCELLED:
        return Colors.red;
      case DeliveryStatusEnum.CONFLICT:
        return Colors.yellow;
      case DeliveryStatusEnum.CREATED:
        return Colors.orange;
      case DeliveryStatusEnum.FINISHED:
        return Colors.purple;
    }
  }

  static String getStatusName(
      BuildContext context, DeliveryStatusEnum? status) {
    if (status == null) {
      return AppLocalizations.of(context).all;
    }
    switch (status) {
      case DeliveryStatusEnum.ASSIGNED:
        return AppLocalizations.of(context).assigned;
      case DeliveryStatusEnum.IN_PROGRESS:
        return AppLocalizations.of(context).inProgress;
      case DeliveryStatusEnum.IN_TRANSIT:
        return AppLocalizations.of(context).inTransit;
      case DeliveryStatusEnum.CANCELLED:
        return AppLocalizations.of(context).cancelled;
      case DeliveryStatusEnum.CONFLICT:
        return AppLocalizations.of(context).conflict;
      case DeliveryStatusEnum.CREATED:
        return AppLocalizations.of(context).created;
      case DeliveryStatusEnum.FINISHED:
        return AppLocalizations.of(context).finished;
    }
  }
}

class DriverUtils {
  static String getStatusName(BuildContext context, DriverStatusEnum? status) {
    if (status == null) {
      return AppLocalizations.of(context).all;
    }
    switch (status) {
      case DriverStatusEnum.PENDING_PICKUP:
        return AppLocalizations.of(context).pendingPickup;
      case DriverStatusEnum.PICKING_UP:
        return AppLocalizations.of(context).pickingUp;
      case DriverStatusEnum.IN_TRANSIT:
        return AppLocalizations.of(context).inTransit;
      case DriverStatusEnum.DELIVERED:
        return AppLocalizations.of(context).delivered;
      case DriverStatusEnum.CANCELLED:
        return AppLocalizations.of(context).cancelled;
      case DriverStatusEnum.IN_RETURN:
        return AppLocalizations.of(context).inReturn;
      case DriverStatusEnum.TRYING_DELIVERY:
        return AppLocalizations.of(context).tryingDelivery;
      case DriverStatusEnum.NOT_DELIVERED:
        return AppLocalizations.of(context).notDelivered;
    }
  }

  static Color getStatusColor(DriverStatusEnum status) {
    switch (status) {
      case DriverStatusEnum.PENDING_PICKUP:
        return Colors.blue;
      case DriverStatusEnum.PICKING_UP:
        return Colors.green;
      case DriverStatusEnum.IN_TRANSIT:
        return Colors.green;
      case DriverStatusEnum.DELIVERED:
        return Colors.green;
      case DriverStatusEnum.CANCELLED:
        return Colors.red;
      case DriverStatusEnum.IN_RETURN:
        return Colors.orange;
      case DriverStatusEnum.TRYING_DELIVERY:
        return Colors.yellow;
      case DriverStatusEnum.NOT_DELIVERED:
        return Colors.red;
    }
  }
}
