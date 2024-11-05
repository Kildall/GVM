//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'package:gvm_flutter/src/models/exceptions/model_parse_exception.dart';

import 'delivery.dart';
import 'delivery_status_enum.dart';
import 'employee.dart';
import 'model_base.dart';

class EmployeeDelivery implements ToJson {
  int? employeeId;
  int? deliveryId;
  DeliveryStatusEnum? status;
  Employee? employee;
  Delivery? delivery;

  EmployeeDelivery({
    this.employeeId,
    this.deliveryId,
    this.status,
    this.employee,
    this.delivery,
  });

  factory EmployeeDelivery.fromJson(Map<String, dynamic> json) {
    try {
      return EmployeeDelivery(
          employeeId: json['employeeId'] as int?,
          deliveryId: json['deliveryId'] as int?,
          status: json['status'] != null
              ? DeliveryStatusEnum.values.byName(json['status'])
              : null,
          employee: json['employee'] != null
              ? Employee.fromJson(json['employee'] as Map<String, dynamic>)
              : null,
          delivery: json['delivery'] != null
              ? Delivery.fromJson(json['delivery'] as Map<String, dynamic>)
              : null);
    } catch (e) {
      throw ModelParseException('EmployeeDelivery', e.toString(), json, e);
    }
  }

  EmployeeDelivery copyWith({
    int? employeeId,
    int? deliveryId,
    DeliveryStatusEnum? status,
    Employee? employee,
    Delivery? delivery,
  }) {
    return EmployeeDelivery(
        employeeId: employeeId ?? this.employeeId,
        deliveryId: deliveryId ?? this.deliveryId,
        status: status ?? this.status,
        employee: employee ?? this.employee,
        delivery: delivery ?? this.delivery);
  }

  EmployeeDelivery copyWithInstance(EmployeeDelivery employeeDelivery) {
    return EmployeeDelivery(
        employeeId: employeeDelivery.employeeId ?? employeeId,
        deliveryId: employeeDelivery.deliveryId ?? deliveryId,
        status: employeeDelivery.status ?? status,
        employee: employeeDelivery.employee ?? employee,
        delivery: employeeDelivery.delivery ?? delivery);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (employeeId != null) 'employeeId': employeeId,
        if (deliveryId != null) 'deliveryId': deliveryId,
        if (status != null) 'status': status,
        if (employee != null) 'employee': employee,
        if (delivery != null) 'delivery': delivery
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeDelivery &&
          runtimeType == other.runtimeType &&
          employeeId == other.employeeId &&
          deliveryId == other.deliveryId &&
          status == other.status &&
          employee == other.employee &&
          delivery == other.delivery;

  @override
  int get hashCode =>
      employeeId.hashCode ^
      deliveryId.hashCode ^
      status.hashCode ^
      employee.hashCode ^
      delivery.hashCode;
}
