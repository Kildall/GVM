import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class GetProductsResponse {
  List<Product> products;

  GetProductsResponse({required this.products});

  factory GetProductsResponse.fromJson(Map<String, dynamic> json) {
    return GetProductsResponse(
      products: createModels(json['products'], Product.fromJson),
    );
  }
}
