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
