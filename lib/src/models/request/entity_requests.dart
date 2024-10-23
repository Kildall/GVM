import 'package:gvm_flutter/src/models/models_library.dart';

class UpdateEntityRequest {
  final int entityId;
  final String name;
  final EntityType type;
  final List<int> permissions;
  final List<int> roles;
  final List<int> users;

  UpdateEntityRequest({
    required this.entityId,
    required this.name,
    required this.type,
    required this.permissions,
    required this.roles,
    required this.users,
  });

  Map<String, dynamic> toJson() => {
        'entityId': entityId,
        'name': name,
        'type': type.name,
        'permissions': permissions,
        'roles': roles,
        'users': users,
      };
}
