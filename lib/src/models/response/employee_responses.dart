import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class GetEmployeesResponse {
  List<Employee> employees;

  GetEmployeesResponse({required this.employees});

  factory GetEmployeesResponse.fromJson(Map<String, dynamic> json) {
    return GetEmployeesResponse(
      employees: createModels<Employee>(json['employees'], Employee.fromJson),
    );
  }
}
