//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'package:gvm_flutter/src/models/exceptions/model_parse_exception.dart';

import 'model_base.dart';
import 'purchase.dart';

class Supplier implements ToJson, Id {
  @override
  int? id;
  String? name;
  bool? enabled;
  List<Purchase>? purchases;
  int? $purchasesCount;

  Supplier({
    this.id,
    this.name,
    this.enabled = true,
    this.purchases,
    this.$purchasesCount,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    try {
      return Supplier(
          id: json['id'] as int?,
          name: json['name'] as String?,
          enabled: json['enabled'] as bool?,
          purchases: json['purchases'] != null
              ? createModels<Purchase>(json['purchases'], Purchase.fromJson)
              : null,
          $purchasesCount: json['_count']?['purchases'] as int?);
    } catch (e) {
      throw ModelParseException('Supplier', e.toString(), json, e);
    }
  }

  Supplier copyWith({
    int? id,
    String? name,
    bool? enabled,
    List<Purchase>? purchases,
    int? $purchasesCount,
  }) {
    return Supplier(
        id: id ?? this.id,
        name: name ?? this.name,
        enabled: enabled ?? this.enabled,
        purchases: purchases ?? this.purchases,
        $purchasesCount: $purchasesCount ?? this.$purchasesCount);
  }

  Supplier copyWithInstance(Supplier supplier) {
    return Supplier(
        id: supplier.id ?? id,
        name: supplier.name ?? name,
        enabled: supplier.enabled ?? enabled,
        purchases: supplier.purchases ?? purchases,
        $purchasesCount: supplier.$purchasesCount ?? $purchasesCount);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (enabled != null) 'enabled': enabled,
        if (purchases != null)
          'purchases': purchases?.map((item) => item.toJson()).toList(),
        if ($purchasesCount != null)
          '_count': {
            if ($purchasesCount != null) 'purchases': $purchasesCount,
          },
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Supplier &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          enabled == other.enabled &&
          areListsEqual(purchases, other.purchases) &&
          $purchasesCount == other.$purchasesCount;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      enabled.hashCode ^
      purchases.hashCode ^
      $purchasesCount.hashCode;
}
