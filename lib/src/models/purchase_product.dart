//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'model_base.dart';
import 'purchase.dart';
import 'product.dart';

class PurchaseProduct implements ToJson {
  int? purchaseId;
  int? productId;
  int? quantity;
  Purchase? purchase;
  Product? product;

  PurchaseProduct({
    this.purchaseId,
    this.productId,
    this.quantity,
    this.purchase,
    this.product,
  });

  factory PurchaseProduct.fromJson(Map<String, dynamic> json) =>
      PurchaseProduct(
          purchaseId: json['purchaseId'] as int?,
          productId: json['productId'] as int?,
          quantity: json['quantity'] as int?,
          purchase: json['purchase'] != null
              ? Purchase.fromJson(json['purchase'] as Map<String, dynamic>)
              : null,
          product: json['product'] != null
              ? Product.fromJson(json['product'] as Map<String, dynamic>)
              : null);

  PurchaseProduct copyWith({
    int? purchaseId,
    int? productId,
    int? quantity,
    Purchase? purchase,
    Product? product,
  }) {
    return PurchaseProduct(
        purchaseId: purchaseId ?? this.purchaseId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        purchase: purchase ?? this.purchase,
        product: product ?? this.product);
  }

  PurchaseProduct copyWithInstance(PurchaseProduct purchaseProduct) {
    return PurchaseProduct(
        purchaseId: purchaseProduct.purchaseId ?? purchaseId,
        productId: purchaseProduct.productId ?? productId,
        quantity: purchaseProduct.quantity ?? quantity,
        purchase: purchaseProduct.purchase ?? purchase,
        product: purchaseProduct.product ?? product);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (purchaseId != null) 'purchaseId': purchaseId,
        if (productId != null) 'productId': productId,
        if (quantity != null) 'quantity': quantity,
        if (purchase != null) 'purchase': purchase,
        if (product != null) 'product': product
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseProduct &&
          runtimeType == other.runtimeType &&
          purchaseId == other.purchaseId &&
          productId == other.productId &&
          quantity == other.quantity &&
          purchase == other.purchase &&
          product == other.product;

  @override
  int get hashCode =>
      purchaseId.hashCode ^
      productId.hashCode ^
      quantity.hashCode ^
      purchase.hashCode ^
      product.hashCode;
}
