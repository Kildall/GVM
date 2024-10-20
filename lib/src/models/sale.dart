import 'package:gvm_flutter/src/models/customer.dart';
import 'package:gvm_flutter/src/models/enums.dart';
import 'package:gvm_flutter/src/models/product.dart';

class ProductSale {
  final int saleId;
  final int productId;
  final int quantity;
  late final Product product;
  late final Sale sale;

  ProductSale(
      {required this.saleId, required this.productId, required this.quantity});

  factory ProductSale.fromJson(Map<String, dynamic> json) {
    final productSale = ProductSale(
        saleId: json['saleId'],
        productId: json['productId'],
        quantity: json['quantity']);
    if (json['product'] != null) {
      productSale.product = Product.fromJson(json['product']);
    }
    if (json['sale'] != null) {
      productSale.product = Product.fromJson(json['sale']);
    }
    return productSale;
  }
}

class Sale {
  final int id;
  final int customerId;
  final DateTime startDate;
  final DateTime lastUpdateDate;
  final SaleStatusEnum status;
  late final Customer? customer;
  late final List<ProductSale>? products;

  Sale({
    required this.id,
    required this.customerId,
    required this.startDate,
    required this.lastUpdateDate,
    required this.status,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    final sale = Sale(
      id: json['id'],
      customerId: json['customerId'],
      startDate: DateTime.parse(json['startDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
      status: SaleStatusEnum.values.firstWhere(
          (e) => e.toString() == 'SaleStatusEnum.${json['status']}'),
    );
    if (json['customer'] != null) {
      sale.customer = Customer.fromJson(json['customer']);
    }
    if (json['products'] != null) {
      sale.products = (json['products'] as List)
          .map((e) => ProductSale.fromJson(e))
          .toList();
    }
    return sale;
  }
}
