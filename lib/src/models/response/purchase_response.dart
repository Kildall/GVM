import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class GetPurchasesResponse {
  List<Purchase> purchases;

  GetPurchasesResponse({required this.purchases});

  factory GetPurchasesResponse.fromJson(Map<String, dynamic> json) {
    return GetPurchasesResponse(
      purchases: createModels(json['purchases'], Purchase.fromJson),
    );
  }
}
