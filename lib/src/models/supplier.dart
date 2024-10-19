class Supplier {
  final int id;
  final String name;
  final bool enabled;

  Supplier({
    required this.id,
    required this.name,
    this.enabled = true,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      enabled: json['enabled'],
    );
  }
}
