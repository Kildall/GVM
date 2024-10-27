//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'employee.dart';
import 'model_base.dart';
import 'purchase_product.dart';
import 'supplier.dart';

class Purchase implements ToJson, Id {
  @override
  int? id;
  int? employeeId;
  int? supplierId;
  DateTime? date;
  double? amount;
  String? description;
  Employee? employee;
  Supplier? supplier;
  List<PurchaseProduct>? products;
  int? $productsCount;

  Purchase({
    this.id,
    this.employeeId,
    this.supplierId,
    this.date,
    this.amount,
    this.description,
    this.employee,
    this.supplier,
    this.products,
    this.$productsCount,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
      id: json['id'] as int?,
      employeeId: json['employeeId'] as int?,
      supplierId: json['supplierId'] as int?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      amount: json['amount'] != null
          ? (json['amount'] is int
              ? (json['amount'] as int).toDouble()
              : json['amount'] as double)
          : null,
      description: json['description'] as String?,
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
      supplier: json['supplier'] != null
          ? Supplier.fromJson(json['supplier'] as Map<String, dynamic>)
          : null,
      products: json['products'] != null
          ? createModels<PurchaseProduct>(
              json['products'], PurchaseProduct.fromJson)
          : null,
      $productsCount: json['_count']?['products'] as int?);

  Purchase copyWith({
    int? id,
    int? employeeId,
    int? supplierId,
    DateTime? date,
    double? amount,
    String? description,
    Employee? employee,
    Supplier? supplier,
    List<PurchaseProduct>? products,
    int? $productsCount,
  }) {
    return Purchase(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        supplierId: supplierId ?? this.supplierId,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        employee: employee ?? this.employee,
        supplier: supplier ?? this.supplier,
        products: products ?? this.products,
        $productsCount: $productsCount ?? this.$productsCount);
  }

  Purchase copyWithInstance(Purchase purchase) {
    return Purchase(
        id: purchase.id ?? id,
        employeeId: purchase.employeeId ?? employeeId,
        supplierId: purchase.supplierId ?? supplierId,
        date: purchase.date ?? date,
        amount: purchase.amount ?? amount,
        description: purchase.description ?? description,
        employee: purchase.employee ?? employee,
        supplier: purchase.supplier ?? supplier,
        products: purchase.products ?? products,
        $productsCount: purchase.$productsCount ?? $productsCount);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (employeeId != null) 'employeeId': employeeId,
        if (supplierId != null) 'supplierId': supplierId,
        if (date != null) 'date': date,
        if (amount != null) 'amount': amount,
        if (description != null) 'description': description,
        if (employee != null) 'employee': employee,
        if (supplier != null) 'supplier': supplier,
        if (products != null)
          'products': products?.map((item) => item.toJson()).toList(),
        if ($productsCount != null)
          '_count': {
            if ($productsCount != null) 'products': $productsCount,
          },
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Purchase &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          employeeId == other.employeeId &&
          supplierId == other.supplierId &&
          date == other.date &&
          amount == other.amount &&
          description == other.description &&
          employee == other.employee &&
          supplier == other.supplier &&
          areListsEqual(products, other.products) &&
          $productsCount == other.$productsCount;

  @override
  int get hashCode =>
      id.hashCode ^
      employeeId.hashCode ^
      supplierId.hashCode ^
      date.hashCode ^
      amount.hashCode ^
      description.hashCode ^
      employee.hashCode ^
      supplier.hashCode ^
      products.hashCode ^
      $productsCount.hashCode;
}
