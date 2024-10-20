class CreateCustomerRequest {
  final String name;
  final String phone;

  CreateCustomerRequest({required this.name, required this.phone});

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
      };
}

class UpdateCustomerRequest {
  final int customerId;
  final String name;
  final String phone;

  UpdateCustomerRequest(
      {required this.customerId, required this.name, required this.phone});

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'name': name,
        'phone': phone,
      };
}
