//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'package:gvm_flutter/src/models/exceptions/model_parse_exception.dart';

import 'customer.dart';
import 'delivery.dart';
import 'employee.dart';
import 'model_base.dart';
import 'product_sale.dart';
import 'sale_status_enum.dart';

class Sale implements ToJson, Id {
  @override
  int? id;
  int? customerId;
  int? employeeId;
  DateTime? startDate;
  DateTime? lastUpdateDate;
  Customer? customer;
  Employee? employee;
  SaleStatusEnum? status;
  List<ProductSale>? products;
  List<Delivery>? deliveries;
  int? $productsCount;
  int? $deliveriesCount;

  Sale({
    this.id,
    this.customerId,
    this.employeeId,
    this.startDate,
    this.lastUpdateDate,
    this.customer,
    this.employee,
    this.status,
    this.products,
    this.deliveries,
    this.$productsCount,
    this.$deliveriesCount,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    try {
      return Sale(
          id: json['id'] as int?,
          customerId: json['customerId'] as int?,
          employeeId: json['employeeId'] as int?,
          startDate: json['startDate'] != null
              ? DateTime.parse(json['startDate'])
              : null,
          lastUpdateDate: json['lastUpdateDate'] != null
              ? DateTime.parse(json['lastUpdateDate'])
              : null,
          customer: json['customer'] != null
              ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
              : null,
          employee: json['employee'] != null
              ? Employee.fromJson(json['employee'] as Map<String, dynamic>)
              : null,
          status: json['status'] != null
              ? SaleStatusEnum.values.byName(json['status'])
              : null,
          products: json['products'] != null
              ? createModels<ProductSale>(
                  json['products'], ProductSale.fromJson)
              : null,
          deliveries: json['deliveries'] != null
              ? createModels<Delivery>(json['deliveries'], Delivery.fromJson)
              : null,
          $productsCount: json['_count']?['products'] as int?,
          $deliveriesCount: json['_count']?['deliveries'] as int?);
    } catch (e) {
      throw ModelParseException('Sale', e.toString(), json, e);
    }
  }

  Sale copyWith({
    int? id,
    int? customerId,
    int? employeeId,
    DateTime? startDate,
    DateTime? lastUpdateDate,
    Customer? customer,
    Employee? employee,
    SaleStatusEnum? status,
    List<ProductSale>? products,
    List<Delivery>? deliveries,
    int? $productsCount,
    int? $deliveriesCount,
  }) {
    return Sale(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        employeeId: employeeId ?? this.employeeId,
        startDate: startDate ?? this.startDate,
        lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
        customer: customer ?? this.customer,
        employee: employee ?? this.employee,
        status: status ?? this.status,
        products: products ?? this.products,
        deliveries: deliveries ?? this.deliveries,
        $productsCount: $productsCount ?? this.$productsCount,
        $deliveriesCount: $deliveriesCount ?? this.$deliveriesCount);
  }

  Sale copyWithInstance(Sale sale) {
    return Sale(
        id: sale.id ?? id,
        customerId: sale.customerId ?? customerId,
        employeeId: sale.employeeId ?? employeeId,
        startDate: sale.startDate ?? startDate,
        lastUpdateDate: sale.lastUpdateDate ?? lastUpdateDate,
        customer: sale.customer ?? customer,
        employee: sale.employee ?? employee,
        status: sale.status ?? status,
        products: sale.products ?? products,
        deliveries: sale.deliveries ?? deliveries,
        $productsCount: sale.$productsCount ?? $productsCount,
        $deliveriesCount: sale.$deliveriesCount ?? $deliveriesCount);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (customerId != null) 'customerId': customerId,
        if (employeeId != null) 'employeeId': employeeId,
        if (startDate != null) 'startDate': startDate,
        if (lastUpdateDate != null) 'lastUpdateDate': lastUpdateDate,
        if (customer != null) 'customer': customer,
        if (employee != null) 'employee': employee,
        if (status != null) 'status': status,
        if (products != null)
          'products': products?.map((item) => item.toJson()).toList(),
        if (deliveries != null)
          'deliveries': deliveries?.map((item) => item.toJson()).toList(),
        if ($productsCount != null || $deliveriesCount != null)
          '_count': {
            if ($productsCount != null) 'products': $productsCount,
            if ($deliveriesCount != null) 'deliveries': $deliveriesCount,
          },
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sale &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          customerId == other.customerId &&
          employeeId == other.employeeId &&
          startDate == other.startDate &&
          lastUpdateDate == other.lastUpdateDate &&
          customer == other.customer &&
          employee == other.employee &&
          status == other.status &&
          areListsEqual(products, other.products) &&
          areListsEqual(deliveries, other.deliveries) &&
          $productsCount == other.$productsCount &&
          $deliveriesCount == other.$deliveriesCount;

  @override
  int get hashCode =>
      id.hashCode ^
      customerId.hashCode ^
      employeeId.hashCode ^
      startDate.hashCode ^
      lastUpdateDate.hashCode ^
      customer.hashCode ^
      employee.hashCode ^
      status.hashCode ^
      products.hashCode ^
      deliveries.hashCode ^
      $productsCount.hashCode ^
      $deliveriesCount.hashCode;
}
