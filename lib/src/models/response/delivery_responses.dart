import 'package:gvm_flutter/src/models/delivery.dart';
import 'package:gvm_flutter/src/models/model_base.dart';

class GetDeliveriesResponse {
  final List<Delivery> deliveries;

  GetDeliveriesResponse({required this.deliveries});

  factory GetDeliveriesResponse.fromJson(Map<String, dynamic> json) {
    return GetDeliveriesResponse(
        deliveries: createModels(json['deliveries'], Delivery.fromJson));
  }
}

class GetEmployeeDeliveriesResponse {
  final List<Delivery> deliveries;

  GetEmployeeDeliveriesResponse({required this.deliveries});

  factory GetEmployeeDeliveriesResponse.fromJson(Map<String, dynamic> json) {
    return GetEmployeeDeliveriesResponse(
        deliveries:
            createModels<Delivery>(json['deliveries'], Delivery.fromJson));
  }
}
