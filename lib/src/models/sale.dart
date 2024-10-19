import 'package:gvm_flutter/src/models/enums.dart';

class Sale {
  final int id;
  final int customerId;
  final DateTime startDate;
  final DateTime lastUpdateDate;
  final SaleStatusEnum status;

  Sale({
    required this.id,
    required this.customerId,
    required this.startDate,
    required this.lastUpdateDate,
    required this.status,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      customerId: json['customerId'],
      startDate: DateTime.parse(json['startDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
      status: SaleStatusEnum.values.firstWhere(
          (e) => e.toString() == 'SaleStatusEnum.${json['status']}'),
    );
  }
}
