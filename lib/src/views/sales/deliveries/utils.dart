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
      case DeliveryStatusEnum.DELIVERED:
        return Colors.green;
      case DeliveryStatusEnum.CANCELED:
        return Colors.red;
      case DeliveryStatusEnum.DISPUTED:
        return Colors.yellow;
      case DeliveryStatusEnum.PENDING_ASSIGNMENT:
        return Colors.orange;
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
      case DeliveryStatusEnum.DELIVERED:
        return AppLocalizations.of(context).delivered;
      case DeliveryStatusEnum.CANCELED:
        return AppLocalizations.of(context).canceled;
      case DeliveryStatusEnum.DISPUTED:
        return AppLocalizations.of(context).disputed;
      case DeliveryStatusEnum.PENDING_ASSIGNMENT:
        return AppLocalizations.of(context).pendingAssignment;
    }
  }
}

class DriverUtils {
  static String getStatusName(BuildContext context, DriverStatusEnum? status) {
    if (status == null) {
      return AppLocalizations.of(context).all;
    }
    switch (status) {
      case DriverStatusEnum.STARTED:
        return AppLocalizations.of(context).started;
      case DriverStatusEnum.IN_PROGRESS:
        return AppLocalizations.of(context).inProgress;
      case DriverStatusEnum.COMPLETED:
        return AppLocalizations.of(context).completed;
      case DriverStatusEnum.CANCELED:
        return AppLocalizations.of(context).canceled;
    }
  }

  static Color getStatusColor(DriverStatusEnum status) {
    switch (status) {
      case DriverStatusEnum.STARTED:
        return Colors.blue;
      case DriverStatusEnum.IN_PROGRESS:
        return Colors.green;
      case DriverStatusEnum.COMPLETED:
        return Colors.green;
      case DriverStatusEnum.CANCELED:
        return Colors.red;
    }
  }
}
