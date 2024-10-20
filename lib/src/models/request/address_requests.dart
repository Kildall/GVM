class CreateAddressRequest {
  final String name;
  final String city;
  final String postalCode;
  final String state;
  final String street1;
  final String? details;
  final int customerId;

  CreateAddressRequest({
    required this.name,
    required this.city,
    required this.postalCode,
    required this.state,
    required this.street1,
    this.details,
    required this.customerId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'city': city,
        'postalCode': postalCode,
        'state': state,
        'street1': street1,
        'details': details,
        'customerId': customerId,
      };
}

class UpdateAddressRequest {
  final int addressId;
  final String name;
  final String city;
  final String postalCode;
  final String state;
  final String street1;
  final String? details;

  UpdateAddressRequest({
    required this.addressId,
    required this.name,
    required this.city,
    required this.postalCode,
    required this.state,
    required this.street1,
    this.details,
  });

  Map<String, dynamic> toJson() => {
        'addressId': addressId,
        'name': name,
        'city': city,
        'postalCode': postalCode,
        'state': state,
        'street1': street1,
        'details': details,
      };
}
