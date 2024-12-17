import 'package:gvm_flutter/src/models/address.dart';

class CreateCustomerRequest {
  final String name;
  final String phone;
  final List<Address> addresses;

  CreateCustomerRequest(
      {required this.name, required this.phone, required this.addresses});

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'addresses': addresses.map((address) => address.toJson()).toList(),
      };
}

class UpdateCustomerRequest {
  final int customerId;
  final String name;
  final String phone;
  final bool enabled;
  final List<Address>? addresses;

  UpdateCustomerRequest(
      {required this.customerId,
      required this.name,
      required this.phone,
      required this.enabled,
      this.addresses});

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'name': name,
        'phone': phone,
        'enabled': enabled,
        if (addresses != null)
          'addresses': addresses!.map((address) => address.toJson()).toList(),
      };
}
