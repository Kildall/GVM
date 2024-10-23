import 'package:gvm_flutter/src/models/model_base.dart';
import 'package:gvm_flutter/src/models/models_library.dart';

class GetUsersResponse {
  final List<User> users;

  GetUsersResponse({required this.users});

  factory GetUsersResponse.fromJson(Map<String, dynamic> json) {
    return GetUsersResponse(
      users: createModels<User>(json['users'], User.fromJson),
    );
  }
}
