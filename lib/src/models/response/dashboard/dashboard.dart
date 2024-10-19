import 'package:gvm_flutter/src/models/response/dashboard/natives/delivery.dart';
import 'package:gvm_flutter/src/models/response/dashboard/natives/sale.dart';

class Dashboard {
  final List<Sale> recentSales;
  final List<Delivery> recentDeliveries;
  final int totalActiveSales;
  final int totalActiveDeliveries;
  final double totalSalesAmount;

  Dashboard(
      {required this.recentSales,
      required this.recentDeliveries,
      required this.totalActiveSales,
      required this.totalActiveDeliveries,
      required this.totalSalesAmount});

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      recentSales:
          (json['recentSales'] as List).map((s) => Sale.fromJson(s)).toList(),
      recentDeliveries: (json['recentDeliveries'] as List)
          .map((d) => Delivery.fromJson(d))
          .toList(),
      totalActiveSales: json['totalActiveSales'],
      totalActiveDeliveries: json['totalActiveDeliveries'],
      totalSalesAmount: json['totalSalesAmount'],
    );
  }
}
