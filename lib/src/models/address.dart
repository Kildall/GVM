import 'package:gvm_flutter/src/models/customer.dart';
import 'package:gvm_flutter/src/models/delivery.dart';

class Address {
  final int id;
  final String name;
  final int customerId;
  final String street1;
  final String? street2;
  final String postalCode;
  final String state;
  final String city;
  final String? details;
  final bool enabled;
  late final Customer? customer;
  late final List<Delivery>? deliveries;

  Address({
    required this.id,
    required this.name,
    required this.customerId,
    required this.street1,
    this.street2,
    required this.postalCode,
    required this.state,
    required this.city,
    this.details,
    this.enabled = true,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    final address = Address(
      id: json['id'],
      name: json['name'],
      customerId: json['customerId'],
      street1: json['street1'],
      street2: json['street2'],
      postalCode: json['postalCode'],
      state: json['state'],
      city: json['city'],
      details: json['details'],
      enabled: json['enabled'],
    );

    if (json['customer'] != null) {
      address.customer = Customer.fromJson(json['customer']);
    }

    if (json['deliveries'] != null) {
      address.deliveries = (json['deliveries'] as List)
          .map((e) => Delivery.fromJson(e))
          .toList();
    }

    return address;
  }

  @override
  String toString() {
    return '$street1, $city, $state, $postalCode';
  }
}
