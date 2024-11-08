import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class GetSalesResponse {
  List<Sale> sales;

  GetSalesResponse({required this.sales});

  factory GetSalesResponse.fromJson(Map<String, dynamic> json) {
    return GetSalesResponse(
      sales: createModels(json['sales'], Sale.fromJson),
    );
  }
}
