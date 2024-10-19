import 'package:gvm_flutter/src/models/response/dashboard/natives/product.dart';
import 'package:jiffy/jiffy.dart';

enum SaleStatus { STARTED, IN_PROGRESS, COMPLETED, CANCELED }

class Sale {
  final int id;
  final String customerName;
  final DateTime startDate;
  final SaleStatus status;
  final List<Product> products;

  Sale({
    required this.id,
    required this.customerName,
    required this.startDate,
    required this.status,
    required this.products,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      customerName: json['customer']['name'],
      startDate: DateTime.parse(json['startDate']),
      status: SaleStatus.values
          .firstWhere((e) => e.toString() == 'SaleStatus.${json['status']}'),
      products:
          (json['products'] as List).map((p) => Product.fromJson(p)).toList(),
    );
  }

  double get totalAmount =>
      products.fold(0, (sum, product) => sum + product.totalPrice);

  String get formattedDate =>
      Jiffy.parseFromDateTime(startDate).format(pattern: 'MMM d, y HH:mm');

  String get statusDisplay => status.toString().split('.').last;

  String get summary =>
      'Sale #$id: $customerName - \$${totalAmount.toStringAsFixed(2)}';
}
