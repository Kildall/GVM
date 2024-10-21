//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'model_base.dart';
import 'customer.dart';
import 'delivery.dart';

class Address implements ToJson, Id {
  @override
  int? id;
  String? name;
  int? customerId;
  String? street1;
  String? street2;
  String? postalCode;
  String? state;
  String? city;
  String? details;
  bool? enabled;
  Customer? customer;
  List<Delivery>? deliveries;
  int? $deliveriesCount;

  Address({
    this.id,
    this.name,
    this.customerId,
    this.street1,
    this.street2,
    this.postalCode,
    this.state,
    this.city,
    this.details,
    this.enabled = true,
    this.customer,
    this.deliveries,
    this.$deliveriesCount,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      id: json['id'] as int?,
      name: json['name'] as String?,
      customerId: json['customerId'] as int?,
      street1: json['street1'] as String?,
      street2: json['street2'] as String?,
      postalCode: json['postalCode'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      details: json['details'] as String?,
      enabled: json['enabled'] as bool?,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      deliveries: json['deliveries'] != null
          ? createModels<Delivery>(json['deliveries'], Delivery.fromJson)
          : null,
      $deliveriesCount: json['_count']?['deliveries'] as int?);

  Address copyWith({
    int? id,
    String? name,
    int? customerId,
    String? street1,
    String? street2,
    String? postalCode,
    String? state,
    String? city,
    String? details,
    bool? enabled,
    Customer? customer,
    List<Delivery>? deliveries,
    int? $deliveriesCount,
  }) {
    return Address(
        id: id ?? this.id,
        name: name ?? this.name,
        customerId: customerId ?? this.customerId,
        street1: street1 ?? this.street1,
        street2: street2 ?? this.street2,
        postalCode: postalCode ?? this.postalCode,
        state: state ?? this.state,
        city: city ?? this.city,
        details: details ?? this.details,
        enabled: enabled ?? this.enabled,
        customer: customer ?? this.customer,
        deliveries: deliveries ?? this.deliveries,
        $deliveriesCount: $deliveriesCount ?? this.$deliveriesCount);
  }

  Address copyWithInstance(Address address) {
    return Address(
        id: address.id ?? id,
        name: address.name ?? name,
        customerId: address.customerId ?? customerId,
        street1: address.street1 ?? street1,
        street2: address.street2 ?? street2,
        postalCode: address.postalCode ?? postalCode,
        state: address.state ?? state,
        city: address.city ?? city,
        details: address.details ?? details,
        enabled: address.enabled ?? enabled,
        customer: address.customer ?? customer,
        deliveries: address.deliveries ?? deliveries,
        $deliveriesCount: address.$deliveriesCount ?? $deliveriesCount);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (customerId != null) 'customerId': customerId,
        if (street1 != null) 'street1': street1,
        if (street2 != null) 'street2': street2,
        if (postalCode != null) 'postalCode': postalCode,
        if (state != null) 'state': state,
        if (city != null) 'city': city,
        if (details != null) 'details': details,
        if (enabled != null) 'enabled': enabled,
        if (customer != null) 'customer': customer,
        if (deliveries != null)
          'deliveries': deliveries?.map((item) => item.toJson()).toList(),
        if ($deliveriesCount != null)
          '_count': {
            if ($deliveriesCount != null) 'deliveries': $deliveriesCount,
          },
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          customerId == other.customerId &&
          street1 == other.street1 &&
          street2 == other.street2 &&
          postalCode == other.postalCode &&
          state == other.state &&
          city == other.city &&
          details == other.details &&
          enabled == other.enabled &&
          customer == other.customer &&
          areListsEqual(deliveries, other.deliveries) &&
          $deliveriesCount == other.$deliveriesCount;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      customerId.hashCode ^
      street1.hashCode ^
      street2.hashCode ^
      postalCode.hashCode ^
      state.hashCode ^
      city.hashCode ^
      details.hashCode ^
      enabled.hashCode ^
      customer.hashCode ^
      deliveries.hashCode ^
      $deliveriesCount.hashCode;
}
