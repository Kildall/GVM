class Customer {
  final int id;
  final String name;
  final String phone;
  final DateTime registrationDate;
  final bool enabled;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.registrationDate,
    this.enabled = true,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      registrationDate: DateTime.parse(json['registrationDate']),
      enabled: json['enabled'],
    );
  }
}
