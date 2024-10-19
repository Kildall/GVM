class DeliveryPerson {
  final int id;
  final String name;
  final String phone;

  DeliveryPerson({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory DeliveryPerson.fromJson(Map<String, dynamic> json) {
    return DeliveryPerson(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
