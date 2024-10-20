import 'package:gvm_flutter/src/models/address.dart';
import 'package:gvm_flutter/src/models/delivery_person.dart';
import 'package:gvm_flutter/src/models/enums.dart';
import 'package:gvm_flutter/src/models/sale.dart';

class Delivery {
  final int id;
  final int saleId;
  final Sale? sale;
  final int? deliveryPersonId;
  final DeliveryPerson? deliveryPerson;
  final int addressId;
  final Address? address;
  final DateTime startDate;
  final DateTime lastUpdateDate;
  final DeliveryStatusEnum status;
  final BusinessStatusEnum businessStatus;
  final DriverStatusEnum? driverStatus;

  Delivery(
      {required this.id,
      required this.saleId,
      required this.addressId,
      required this.startDate,
      required this.lastUpdateDate,
      required this.status,
      required this.businessStatus,
      required this.deliveryPersonId,
      this.sale,
      this.deliveryPerson,
      this.address,
      this.driverStatus});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    final delivery = Delivery(
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
      sale: json['sale'] != null ? Sale.fromJson(json['sale']) : null,
      deliveryPerson: json['deliveryPerson'] != null
          ? DeliveryPerson.fromJson(json['deliveryPerson'])
          : null,
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
    );

    return delivery;
  }
}
