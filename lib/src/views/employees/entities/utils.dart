import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/models/entity_type.dart';

String mapEntityTypeToName(EntityType? type, BuildContext context) {
  switch (type) {
    case EntityType.Role:
      return AppLocalizations.of(context).role;
    case EntityType.Permission:
      return AppLocalizations.of(context).permission;
    default:
      return AppLocalizations.of(context).unknownType;
  }
}
