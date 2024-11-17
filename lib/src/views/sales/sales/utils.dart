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
