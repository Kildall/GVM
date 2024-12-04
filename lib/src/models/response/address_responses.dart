import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class GetAddressesResponse {
  final List<Address> addresses;

  GetAddressesResponse({required this.addresses});

  static GetAddressesResponse fromJson(Map<String, dynamic> json) {
    return GetAddressesResponse(
      addresses: createModels(json['addresses'], Address.fromJson),
    );
  }
}
