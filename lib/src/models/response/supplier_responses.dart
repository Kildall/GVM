import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class GetSuppliersResponse {
  final List<Supplier> suppliers;

  GetSuppliersResponse({required this.suppliers});

  factory GetSuppliersResponse.fromJson(Map<String, dynamic> json) =>
      GetSuppliersResponse(
          suppliers:
              createModels<Supplier>(json['suppliers'], Supplier.fromJson));
}
