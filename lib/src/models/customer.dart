import 'package:gvm_flutter/src/models/address.dart';
import 'package:gvm_flutter/src/models/sale.dart';

class Customer {
  final int id;
  final String name;
  final String phone;
  final DateTime registrationDate;
  final bool enabled;
  late final List<Address>? addresses;
  late final List<Sale>? sales;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.registrationDate,
    this.enabled = true,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    final customer = Customer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      registrationDate: DateTime.parse(json['registrationDate']),
      enabled: json['enabled'],
    );

    if (json['addresses'] != null) {
      customer.addresses =
          (json['addresses'] as List).map((e) => Address.fromJson(e)).toList();
    }

    if (json['sales'] != null) {
      customer.sales =
          (json['sales'] as List).map((e) => Sale.fromJson(e)).toList();
    }

    return customer;
  }
}
