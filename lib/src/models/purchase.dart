import 'package:gvm_flutter/src/models/employee.dart';
import 'package:gvm_flutter/src/models/product.dart';
import 'package:gvm_flutter/src/models/supplier.dart';

class Purchase {
  final int id;
  final int employeeId;
  late final Employee employee;
  final int supplierId;
  late final Supplier supplier;
  final DateTime date;
  final double amount;
  final String description;
  late final List<PurchaseProduct> products;

  Purchase({
    required this.id,
    required this.employeeId,
    required this.supplierId,
    required this.date,
    required this.amount,
    required this.description,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    final purchase = Purchase(
      id: json['id'],
      employeeId: json['employeeId'],
      supplierId: json['supplierId'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      description: json['description'],
    );

    if (json['employee'] != null) {
      purchase.employee = Employee.fromJson(json['employee']);
    }

    if (json['supplier'] != null) {
      purchase.supplier = Supplier.fromJson(json['supplier']);
    }

    return purchase;
  }
}
