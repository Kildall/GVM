import 'package:gvm_flutter/src/models/delivery.dart';
import 'package:gvm_flutter/src/models/sale.dart';

class DashboardResponse {
  final List<Sale> recentSales;
  final List<Delivery> recentDeliveries;
  final int totalActiveSales;
  final int totalActiveDeliveries;
  final double totalSalesAmount;

  DashboardResponse(
      {required this.recentSales,
      required this.recentDeliveries,
      required this.totalActiveSales,
      required this.totalActiveDeliveries,
      required this.totalSalesAmount});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      recentSales:
          (json['recentSales'] as List).map((s) => Sale.fromJson(s)).toList(),
      recentDeliveries: (json['recentDeliveries'] as List)
          .map((d) => Delivery.fromJson(d))
          .toList(),
      totalActiveSales: json['totalActiveSales'],
      totalActiveDeliveries: json['totalActiveDeliveries'],
      totalSalesAmount: json['totalSalesAmount'].toDouble(),
    );
  }
}
