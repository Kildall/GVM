import 'package:gvm_flutter/src/models/enums.dart';

class Delivery {
  final int id;
  final int saleId;
  final int? deliveryPersonId;
  final int addressId;
  final DateTime startDate;
  final DateTime lastUpdateDate;
  final DeliveryStatusEnum status;
  final BusinessStatusEnum businessStatus;
  final DriverStatusEnum? driverStatus;

  Delivery({
    required this.id,
    required this.saleId,
    this.deliveryPersonId,
    required this.addressId,
    required this.startDate,
    required this.lastUpdateDate,
    required this.status,
    required this.businessStatus,
    this.driverStatus,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'],
      saleId: json['saleId'],
      deliveryPersonId: json['deliveryPersonId'],
      addressId: json['addressId'],
      startDate: DateTime.parse(json['startDate']),
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
      status: DeliveryStatusEnum.values.firstWhere(
          (e) => e.toString() == 'DeliveryStatusEnum.${json['status']}'),
      businessStatus: BusinessStatusEnum.values.firstWhere((e) =>
          e.toString() == 'BusinessStatusEnum.${json['businessStatus']}'),
      driverStatus: json['driverStatus'] != null
          ? DriverStatusEnum.values.firstWhere(
              (e) => e.toString() == 'DriverStatusEnum.${json['driverStatus']}')
          : null,
    );
  }
}
