//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'model_base.dart';
import 'address.dart';
import 'sale.dart';

class Customer implements ToJson, Id {
  @override
  int? id;
  String? name;
  String? phone;
  DateTime? registrationDate;
  bool? enabled;
  List<Address>? addresses;
  List<Sale>? sales;
  int? $addressesCount;
  int? $salesCount;

  Customer({
    this.id,
    this.name,
    this.phone,
    this.registrationDate,
    this.enabled = true,
    this.addresses,
    this.sales,
    this.$addressesCount,
    this.$salesCount,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      registrationDate: json['registrationDate'] != null
          ? DateTime.parse(json['registrationDate'])
          : null,
      enabled: json['enabled'] as bool?,
      addresses: json['addresses'] != null
          ? createModels<Address>(json['addresses'], Address.fromJson)
          : null,
      sales: json['sales'] != null
          ? createModels<Sale>(json['sales'], Sale.fromJson)
          : null,
      $addressesCount: json['_count']?['addresses'] as int?,
      $salesCount: json['_count']?['sales'] as int?);

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    DateTime? registrationDate,
    bool? enabled,
    List<Address>? addresses,
    List<Sale>? sales,
    int? $addressesCount,
    int? $salesCount,
  }) {
    return Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        registrationDate: registrationDate ?? this.registrationDate,
        enabled: enabled ?? this.enabled,
        addresses: addresses ?? this.addresses,
        sales: sales ?? this.sales,
        $addressesCount: $addressesCount ?? this.$addressesCount,
        $salesCount: $salesCount ?? this.$salesCount);
  }

  Customer copyWithInstance(Customer customer) {
    return Customer(
        id: customer.id ?? id,
        name: customer.name ?? name,
        phone: customer.phone ?? phone,
        registrationDate: customer.registrationDate ?? registrationDate,
        enabled: customer.enabled ?? enabled,
        addresses: customer.addresses ?? addresses,
        sales: customer.sales ?? sales,
        $addressesCount: customer.$addressesCount ?? $addressesCount,
        $salesCount: customer.$salesCount ?? $salesCount);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (registrationDate != null) 'registrationDate': registrationDate,
        if (enabled != null) 'enabled': enabled,
        if (addresses != null)
          'addresses': addresses?.map((item) => item.toJson()).toList(),
        if (sales != null)
          'sales': sales?.map((item) => item.toJson()).toList(),
        if ($addressesCount != null || $salesCount != null)
          '_count': {
            if ($addressesCount != null) 'addresses': $addressesCount,
            if ($salesCount != null) 'sales': $salesCount,
          },
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          phone == other.phone &&
          registrationDate == other.registrationDate &&
          enabled == other.enabled &&
          areListsEqual(addresses, other.addresses) &&
          areListsEqual(sales, other.sales) &&
          $addressesCount == other.$addressesCount &&
          $salesCount == other.$salesCount;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      registrationDate.hashCode ^
      enabled.hashCode ^
      addresses.hashCode ^
      sales.hashCode ^
      $addressesCount.hashCode ^
      $salesCount.hashCode;
}
