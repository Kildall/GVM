//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'delivery.dart';
import 'employee_delivery.dart';
import 'exceptions/model_parse_exception.dart';
import 'model_base.dart';
import 'purchase.dart';
import 'sale.dart';
import 'user.dart';

class Employee implements ToJson, Id {
  @override
  int? id;
  String? name;
  String? position;
  bool? enabled;
  List<Purchase>? purchases;
  List<Sale>? sales;
  List<Delivery>? deliveries;
  List<EmployeeDelivery>? employeeDelivery;
  User? user;
  int? userId;

  Employee({
    this.id,
    this.name,
    this.position,
    this.enabled = true,
    this.purchases,
    this.sales,
    this.deliveries,
    this.employeeDelivery,
    this.user,
    this.userId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    try {
      return Employee(
          id: json['id'] as int?,
          name: json['name'] as String?,
          position: json['position'] as String?,
          enabled: json['enabled'] as bool?,
          purchases: json['purchases'] != null
              ? createModels<Purchase>(json['purchases'], Purchase.fromJson)
              : null,
          sales: json['sales'] != null
              ? createModels<Sale>(json['sales'], Sale.fromJson)
              : null,
          deliveries: json['deliveries'] != null
              ? createModels<Delivery>(json['deliveries'], Delivery.fromJson)
              : null,
          employeeDelivery: json['employeeDelivery'] != null
              ? createModels<EmployeeDelivery>(
                  json['employeeDelivery'], EmployeeDelivery.fromJson)
              : null,
          user: json['user'] != null
              ? User.fromJson(json['user'] as Map<String, dynamic>)
              : null,
          userId: json['userId'] as int?);
    } catch (e) {
      throw ModelParseException('Employee', e.toString(), json, e);
    }
  }

  Employee copyWith({
    int? id,
    String? name,
    String? position,
    bool? enabled,
    List<Purchase>? purchases,
    List<Sale>? sales,
    List<Delivery>? deliveries,
    List<EmployeeDelivery>? employeeDelivery,
    User? user,
    int? userId,
    int? $purchasesCount,
    int? $salesCount,
    int? $deliveriesCount,
    int? $employeeDeliveryCount,
  }) {
    return Employee(
        id: id ?? this.id,
        name: name ?? this.name,
        position: position ?? this.position,
        enabled: enabled ?? this.enabled,
        purchases: purchases ?? this.purchases,
        sales: sales ?? this.sales,
        deliveries: deliveries ?? this.deliveries,
        employeeDelivery: employeeDelivery ?? this.employeeDelivery,
        user: user ?? this.user,
        userId: userId ?? this.userId);
  }

  Employee copyWithInstance(Employee employee) {
    return Employee(
        id: employee.id ?? id,
        name: employee.name ?? name,
        position: employee.position ?? position,
        enabled: employee.enabled ?? enabled,
        purchases: employee.purchases ?? purchases,
        sales: employee.sales ?? sales,
        deliveries: employee.deliveries ?? deliveries,
        employeeDelivery: employee.employeeDelivery ?? employeeDelivery,
        user: employee.user ?? user,
        userId: employee.userId ?? userId);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (position != null) 'position': position,
        if (enabled != null) 'enabled': enabled,
        if (purchases != null)
          'purchases': purchases?.map((item) => item.toJson()).toList(),
        if (sales != null)
          'sales': sales?.map((item) => item.toJson()).toList(),
        if (deliveries != null)
          'deliveries': deliveries?.map((item) => item.toJson()).toList(),
        if (employeeDelivery != null)
          'employeeDelivery':
              employeeDelivery?.map((item) => item.toJson()).toList(),
        if (user != null) 'user': user,
        if (userId != null) 'userId': userId,
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Employee &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          position == other.position &&
          enabled == other.enabled &&
          areListsEqual(purchases, other.purchases) &&
          areListsEqual(sales, other.sales) &&
          areListsEqual(deliveries, other.deliveries) &&
          areListsEqual(employeeDelivery, other.employeeDelivery) &&
          user == other.user &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      position.hashCode ^
      enabled.hashCode ^
      purchases.hashCode ^
      sales.hashCode ^
      deliveries.hashCode ^
      employeeDelivery.hashCode ^
      user.hashCode ^
      userId.hashCode;
}
