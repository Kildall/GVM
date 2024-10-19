class Employee {
  final int id;
  final String name;
  final String position;
  final bool enabled;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    this.enabled = true,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      enabled: json['enabled'],
    );
  }
}
