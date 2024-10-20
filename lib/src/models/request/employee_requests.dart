class CreateEmployeeRequest {
  final String name;
  final String position;

  CreateEmployeeRequest({required this.name, required this.position});

  Map<String, dynamic> toJson() => {
        'name': name,
        'position': position,
      };
}

class UpdateEmployeeRequest {
  final int employeeId;
  final String name;
  final String position;

  UpdateEmployeeRequest({
    required this.employeeId,
    required this.name,
    required this.position,
  });

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'name': name,
        'position': position,
      };
}
