//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'model_base.dart';
import 'sale.dart';
import 'employee.dart';
import 'address.dart';
import 'delivery_status_enum.dart';
import 'business_status_enum.dart';
import 'driver_status_enum.dart';
import 'employee_delivery.dart';

class Delivery implements ToJson, Id {
  @override
  int? id;
  int? saleId;
  int? employeeId;
  int? addressId;
  DateTime? startDate;
  DateTime? lastUpdateDate;
  Sale? sale;
  Employee? employee;
  Address? address;
  DeliveryStatusEnum? status;
  BusinessStatusEnum? businessStatus;
  DriverStatusEnum? driverStatus;
  EmployeeDelivery? employeeDelivery;

  Delivery({
    this.id,
    this.saleId,
    this.employeeId,
    this.addressId,
    this.startDate,
    this.lastUpdateDate,
    this.sale,
    this.employee,
    this.address,
    this.status,
    this.businessStatus,
    this.driverStatus,
    this.employeeDelivery,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
      id: json['id'] as int?,
      saleId: json['saleId'] as int?,
      employeeId: json['employeeId'] as int?,
      addressId: json['addressId'] as int?,
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      lastUpdateDate: json['lastUpdateDate'] != null
          ? DateTime.parse(json['lastUpdateDate'])
          : null,
      sale: json['sale'] != null
          ? Sale.fromJson(json['sale'] as Map<String, dynamic>)
          : null,
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      status: DeliveryStatusEnum.values.byName(json['status']),
      businessStatus: BusinessStatusEnum.values.byName(json['businessStatus']),
      driverStatus: DriverStatusEnum.values.byName(json['driverStatus']),
      employeeDelivery: json['employeeDelivery'] != null
          ? EmployeeDelivery.fromJson(
              json['employeeDelivery'] as Map<String, dynamic>)
          : null);

  Delivery copyWith({
    int? id,
    int? saleId,
    int? employeeId,
    int? addressId,
    DateTime? startDate,
    DateTime? lastUpdateDate,
    Sale? sale,
    Employee? employee,
    Address? address,
    DeliveryStatusEnum? status,
    BusinessStatusEnum? businessStatus,
    DriverStatusEnum? driverStatus,
    EmployeeDelivery? employeeDelivery,
  }) {
    return Delivery(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        employeeId: employeeId ?? this.employeeId,
        addressId: addressId ?? this.addressId,
        startDate: startDate ?? this.startDate,
        lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
        sale: sale ?? this.sale,
        employee: employee ?? this.employee,
        address: address ?? this.address,
        status: status ?? this.status,
        businessStatus: businessStatus ?? this.businessStatus,
        driverStatus: driverStatus ?? this.driverStatus,
        employeeDelivery: employeeDelivery ?? this.employeeDelivery);
  }

  Delivery copyWithInstance(Delivery delivery) {
    return Delivery(
        id: delivery.id ?? id,
        saleId: delivery.saleId ?? saleId,
        employeeId: delivery.employeeId ?? employeeId,
        addressId: delivery.addressId ?? addressId,
        startDate: delivery.startDate ?? startDate,
        lastUpdateDate: delivery.lastUpdateDate ?? lastUpdateDate,
        sale: delivery.sale ?? sale,
        employee: delivery.employee ?? employee,
        address: delivery.address ?? address,
        status: delivery.status ?? status,
        businessStatus: delivery.businessStatus ?? businessStatus,
        driverStatus: delivery.driverStatus ?? driverStatus,
        employeeDelivery: delivery.employeeDelivery ?? employeeDelivery);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (saleId != null) 'saleId': saleId,
        if (employeeId != null) 'employeeId': employeeId,
        if (addressId != null) 'addressId': addressId,
        if (startDate != null) 'startDate': startDate,
        if (lastUpdateDate != null) 'lastUpdateDate': lastUpdateDate,
        if (sale != null) 'sale': sale,
        if (employee != null) 'employee': employee,
        if (address != null) 'address': address,
        if (status != null) 'status': status,
        if (businessStatus != null) 'businessStatus': businessStatus,
        if (driverStatus != null) 'driverStatus': driverStatus,
        if (employeeDelivery != null) 'employeeDelivery': employeeDelivery
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Delivery &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          saleId == other.saleId &&
          employeeId == other.employeeId &&
          addressId == other.addressId &&
          startDate == other.startDate &&
          lastUpdateDate == other.lastUpdateDate &&
          sale == other.sale &&
          employee == other.employee &&
          address == other.address &&
          status == other.status &&
          businessStatus == other.businessStatus &&
          driverStatus == other.driverStatus &&
          employeeDelivery == other.employeeDelivery;

  @override
  int get hashCode =>
      id.hashCode ^
      saleId.hashCode ^
      employeeId.hashCode ^
      addressId.hashCode ^
      startDate.hashCode ^
      lastUpdateDate.hashCode ^
      sale.hashCode ^
      employee.hashCode ^
      address.hashCode ^
      status.hashCode ^
      businessStatus.hashCode ^
      driverStatus.hashCode ^
      employeeDelivery.hashCode;
}
