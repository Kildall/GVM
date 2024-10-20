import 'package:gvm_flutter/src/models/purchase.dart';
import 'package:gvm_flutter/src/models/sale.dart';

class PurchaseProduct {
  final int purchaseId;
  final int productId;
  final int quantity;
  late final Purchase purchase;
  late final Product product;

  PurchaseProduct({
    required this.purchaseId,
    required this.productId,
    required this.quantity,
  });

  factory PurchaseProduct.fromJson(Map<String, dynamic> json) {
    final purchaseProduct = PurchaseProduct(
      purchaseId: json['purchaseId'],
      productId: json['productId'],
      quantity: json['quantity'],
    );

    if (json['purchase'] != null) {
      purchaseProduct.purchase = Purchase.fromJson(json['purchase']);
    }

    if (json['product'] != null) {
      purchaseProduct.product = Product.fromJson(json['product']);
    }

    return purchaseProduct;
  }
}

class Product {
  final int id;
  final String name;
  final int quantity;
  final double measure;
  final String brand;
  final double price;
  final bool enabled;
  late final List<PurchaseProduct>? purchases;
  late final List<ProductSale>? sales;

  Product({
    required this.id,
    required this.name,
    this.quantity = 0,
    required this.measure,
    required this.brand,
    required this.price,
    this.enabled = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final product = Product(
      id: json['id'],
      name: json['name'],
      measure: json['measure'],
      quantity: json['quantity'],
      brand: json['brand'],
      price: json['price'],
      enabled: json['enabled'],
    );

    if (json['purchases'] != null) {
      product.purchases = (json['purchases'] as List)
          .map((e) => PurchaseProduct.fromJson(e))
          .toList();
    }

    if (json['sales'] != null) {
      product.sales =
          (json['sales'] as List).map((e) => ProductSale.fromJson(e)).toList();
    }

    return product;
  }
}
