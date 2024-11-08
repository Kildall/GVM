import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class GetCustomersResponse {
  final List<Customer> customers;

  GetCustomersResponse({required this.customers});

  static GetCustomersResponse fromJson(Map<String, dynamic> json) {
    return GetCustomersResponse(
      customers: createModels(json['customers'], Customer.fromJson),
    );
  }
}
