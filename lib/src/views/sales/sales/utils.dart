import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class SalesUtils {
  static Color getStatusColor(SaleStatusEnum status) {
    switch (status) {
      case SaleStatusEnum.CREATED:
        return Colors.blue;
      case SaleStatusEnum.DELIVERED:
        return Colors.green;
      case SaleStatusEnum.CANCELLED:
        return Colors.red;
      case SaleStatusEnum.IN_PROGRESS:
        return Colors.orange;
      case SaleStatusEnum.PREPARING:
        return Colors.yellow;
      case SaleStatusEnum.READY:
        return Colors.purple;
      case SaleStatusEnum.IN_DELIVERY:
        return Colors.teal;
    }
  }

  static String getStatusName(BuildContext context, SaleStatusEnum status) {
    switch (status) {
      case SaleStatusEnum.CREATED:
        return AppLocalizations.of(context).created;
      case SaleStatusEnum.DELIVERED:
        return AppLocalizations.of(context).delivered;
      case SaleStatusEnum.CANCELLED:
        return AppLocalizations.of(context).cancelled;
      case SaleStatusEnum.IN_PROGRESS:
        return AppLocalizations.of(context).inProgress;
      case SaleStatusEnum.IN_DELIVERY:
        return AppLocalizations.of(context).inDelivery;
      case SaleStatusEnum.PREPARING:
        return AppLocalizations.of(context).preparing;
      case SaleStatusEnum.READY:
        return AppLocalizations.of(context).ready;
    }
  }
}

class BusinessUtils {
  static String getStatusName(BuildContext context, BusinessStatusEnum status) {
    switch (status) {
      case BusinessStatusEnum.PENDING:
        return AppLocalizations.of(context).pending;
      case BusinessStatusEnum.IN_PROGRESS:
        return AppLocalizations.of(context).inProgress;
      case BusinessStatusEnum.IN_TRANSIT:
        return AppLocalizations.of(context).inTransit;
      case BusinessStatusEnum.IN_RETURN:
        return AppLocalizations.of(context).inReturn;
      case BusinessStatusEnum.DELIVERED:
        return AppLocalizations.of(context).delivered;
      case BusinessStatusEnum.CANCELLED:
        return AppLocalizations.of(context).cancelled;
      case BusinessStatusEnum.NOT_DELIVERED:
        return AppLocalizations.of(context).notDelivered;
    }
  }

  static Color getStatusColor(BusinessStatusEnum status) {
    switch (status) {
      case BusinessStatusEnum.PENDING:
        return Colors.blue;
      case BusinessStatusEnum.IN_PROGRESS:
        return Colors.green;
      case BusinessStatusEnum.IN_TRANSIT:
        return Colors.orange;
      case BusinessStatusEnum.IN_RETURN:
        return Colors.purple;
      case BusinessStatusEnum.DELIVERED:
        return Colors.teal;
      case BusinessStatusEnum.CANCELLED:
        return Colors.red;
      case BusinessStatusEnum.NOT_DELIVERED:
        return Colors.grey;
    }
  }
}
