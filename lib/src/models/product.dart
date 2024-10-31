//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'model_base.dart';
import 'product_sale.dart';
import 'purchase_product.dart';

class Product implements ToJson, Id {
  @override
  int? id;
  String? name;
  int? quantity;
  double? measure;
  String? brand;
  double? price;
  bool? enabled;
  List<PurchaseProduct>? purchases;
  List<ProductSale>? sales;
  int? $purchasesCount;
  int? $salesCount;

  Product({
    this.id,
    this.name,
    this.quantity = 0,
    this.measure,
    this.brand,
    this.price,
    this.enabled = true,
    this.purchases,
    this.sales,
    this.$purchasesCount,
    this.$salesCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int?,
      name: json['name'] as String?,
      quantity: json['quantity'] as int?,
      measure: json['measure'] != null
          ? (json['measure'] is int
              ? (json['measure'] as int).toDouble()
              : json['measure'] as double)
          : null,
      brand: json['brand'] as String?,
      price: json['price'] != null
          ? (json['price'] is int
              ? (json['price'] as int).toDouble()
              : json['price'] as double)
          : null,
      enabled: json['enabled'] as bool?,
      purchases: json['purchases'] != null
          ? createModels<PurchaseProduct>(
              json['purchases'], PurchaseProduct.fromJson)
          : null,
      sales: json['sales'] != null
          ? createModels<ProductSale>(json['sales'], ProductSale.fromJson)
          : null,
      $purchasesCount: json['_count']?['purchases'] as int?,
      $salesCount: json['_count']?['sales'] as int?);

  Product copyWith({
    int? id,
    String? name,
    int? quantity,
    double? measure,
    String? brand,
    double? price,
    bool? enabled,
    List<PurchaseProduct>? purchases,
    List<ProductSale>? sales,
    int? $purchasesCount,
    int? $salesCount,
  }) {
    return Product(
        id: id ?? this.id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        measure: measure ?? this.measure,
        brand: brand ?? this.brand,
        price: price ?? this.price,
        enabled: enabled ?? this.enabled,
        purchases: purchases ?? this.purchases,
        sales: sales ?? this.sales,
        $purchasesCount: $purchasesCount ?? this.$purchasesCount,
        $salesCount: $salesCount ?? this.$salesCount);
  }

  Product copyWithInstance(Product product) {
    return Product(
        id: product.id ?? id,
        name: product.name ?? name,
        quantity: product.quantity ?? quantity,
        measure: product.measure ?? measure,
        brand: product.brand ?? brand,
        price: product.price ?? price,
        enabled: product.enabled ?? enabled,
        purchases: product.purchases ?? purchases,
        sales: product.sales ?? sales,
        $purchasesCount: product.$purchasesCount ?? $purchasesCount,
        $salesCount: product.$salesCount ?? $salesCount);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (quantity != null) 'quantity': quantity,
        if (measure != null) 'measure': measure,
        if (brand != null) 'brand': brand,
        if (price != null) 'price': price,
        if (enabled != null) 'enabled': enabled,
        if (purchases != null)
          'purchases': purchases?.map((item) => item.toJson()).toList(),
        if (sales != null)
          'sales': sales?.map((item) => item.toJson()).toList(),
        if ($purchasesCount != null || $salesCount != null)
          '_count': {
            if ($purchasesCount != null) 'purchases': $purchasesCount,
            if ($salesCount != null) 'sales': $salesCount,
          },
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          quantity == other.quantity &&
          measure == other.measure &&
          brand == other.brand &&
          price == other.price &&
          enabled == other.enabled &&
          areListsEqual(purchases, other.purchases) &&
          areListsEqual(sales, other.sales) &&
          $purchasesCount == other.$purchasesCount &&
          $salesCount == other.$salesCount;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      quantity.hashCode ^
      measure.hashCode ^
      brand.hashCode ^
      price.hashCode ^
      enabled.hashCode ^
      purchases.hashCode ^
      sales.hashCode ^
      $purchasesCount.hashCode ^
      $salesCount.hashCode;
}
