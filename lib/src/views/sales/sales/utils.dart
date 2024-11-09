import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class SalesUtils {
  static Color getStatusColor(SaleStatusEnum status) {
    switch (status) {
      case SaleStatusEnum.STARTED:
        return Colors.blue;
      case SaleStatusEnum.COMPLETED:
        return Colors.green;
      case SaleStatusEnum.CANCELED:
        return Colors.red;
      case SaleStatusEnum.IN_PROGRESS:
        return Colors.orange;
    }
  }

  static String getStatusName(BuildContext context, SaleStatusEnum status) {
    switch (status) {
      case SaleStatusEnum.STARTED:
        return AppLocalizations.of(context).started;
      case SaleStatusEnum.COMPLETED:
        return AppLocalizations.of(context).completed;
      case SaleStatusEnum.CANCELED:
        return AppLocalizations.of(context).canceled;
      case SaleStatusEnum.IN_PROGRESS:
        return AppLocalizations.of(context).inProgress;
    }
  }
}
