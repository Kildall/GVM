//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'package:gvm_flutter/src/models/exceptions/model_parse_exception.dart';

import 'model_base.dart';
import 'product.dart';
import 'sale.dart';

class ProductSale implements ToJson {
  int? saleId;
  int? productId;
  int? quantity;
  Sale? sale;
  Product? product;

  ProductSale({
    this.saleId,
    this.productId,
    this.quantity,
    this.sale,
    this.product,
  });

  factory ProductSale.fromJson(Map<String, dynamic> json) {
    try {
      return ProductSale(
          saleId: json['saleId'] as int?,
          productId: json['productId'] as int?,
          quantity: json['quantity'] as int?,
          sale: json['sale'] != null
              ? Sale.fromJson(json['sale'] as Map<String, dynamic>)
              : null,
          product: json['product'] != null
              ? Product.fromJson(json['product'] as Map<String, dynamic>)
              : null);
    } catch (e) {
      throw ModelParseException('ProductSale', e.toString(), json, e);
    }
  }

  ProductSale copyWith({
    int? saleId,
    int? productId,
    int? quantity,
    Sale? sale,
    Product? product,
  }) {
    return ProductSale(
        saleId: saleId ?? this.saleId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        sale: sale ?? this.sale,
        product: product ?? this.product);
  }

  ProductSale copyWithInstance(ProductSale productSale) {
    return ProductSale(
        saleId: productSale.saleId ?? saleId,
        productId: productSale.productId ?? productId,
        quantity: productSale.quantity ?? quantity,
        sale: productSale.sale ?? sale,
        product: productSale.product ?? product);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (saleId != null) 'saleId': saleId,
        if (productId != null) 'productId': productId,
        if (quantity != null) 'quantity': quantity,
        if (sale != null) 'sale': sale,
        if (product != null) 'product': product
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSale &&
          runtimeType == other.runtimeType &&
          saleId == other.saleId &&
          productId == other.productId &&
          quantity == other.quantity &&
          sale == other.sale &&
          product == other.product;

  @override
  int get hashCode =>
      saleId.hashCode ^
      productId.hashCode ^
      quantity.hashCode ^
      sale.hashCode ^
      product.hashCode;
}
