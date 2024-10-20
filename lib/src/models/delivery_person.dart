import 'package:gvm_flutter/src/models/delivery.dart';
import 'package:gvm_flutter/src/models/enums.dart';

class DeliveryPersonDelivery {
  final int deliveryPersonId;
  late final DeliveryPerson deliveryPerson;
  final int deliveryId;
  late final Delivery delivery;
  final DeliveryStatusEnum status;

  DeliveryPersonDelivery({
    required this.deliveryPersonId,
    required this.deliveryId,
    required this.status,
  });

  factory DeliveryPersonDelivery.fromJson(Map<String, dynamic> json) {
    final deliveryPersonDelivery = DeliveryPersonDelivery(
      deliveryPersonId: json['deliveryPersonId'],
      deliveryId: json['deliveryId'],
      status: DeliveryStatusEnum.values.firstWhere(
          (e) => e.toString() == 'DeliveryStatusEnum.${json['status']}'),
    );

    if (json['deliveryPerson'] != null) {
      deliveryPersonDelivery.deliveryPerson =
          DeliveryPerson.fromJson(json['deliveryPerson']);
    }

    if (json['delivery'] != null) {
      deliveryPersonDelivery.delivery = Delivery.fromJson(json['delivery']);
    }

    return deliveryPersonDelivery;
  }
}

class DeliveryPerson {
  final int id;
  final String name;
  final String phone;
  late final List<DeliveryPersonDelivery> deliveries;

  DeliveryPerson({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory DeliveryPerson.fromJson(Map<String, dynamic> json) {
    final deliveryPerson = DeliveryPerson(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );

    if (json['deliveries'] != null) {
      deliveryPerson.deliveries = (json['deliveries'] as List)
          .map((e) => DeliveryPersonDelivery.fromJson(e))
          .toList();
    }

    return deliveryPerson;
  }
}
