import 'package:gvm_flutter/src/models/purchase.dart';

class Supplier {
  final int id;
  final String name;
  final bool enabled;
  late final List<Purchase>? purchases;

  Supplier({
    required this.id,
    required this.name,
    this.enabled = true,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    final supplier = Supplier(
      id: json['id'],
      name: json['name'],
      enabled: json['enabled'],
    );

    if (json['purchases'] != null) {
      supplier.purchases =
          (json['purchases'] as List).map((e) => Purchase.fromJson(e)).toList();
    }

    return supplier;
  }
}
