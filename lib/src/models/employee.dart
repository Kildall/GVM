import 'package:gvm_flutter/src/models/purchase.dart';

class Employee {
  final int id;
  final String name;
  final String position;
  final bool enabled;
  late final List<Purchase>? purchases;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    this.enabled = true,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    final employee = Employee(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      enabled: json['enabled'],
    );

    if (json['purchases'] != null) {
      employee.purchases =
          (json['purchases'] as List).map((e) => Purchase.fromJson(e)).toList();
    }

    return employee;
  }
}
