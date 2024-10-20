import 'package:gvm_flutter/src/models/enums.dart';
import 'package:gvm_flutter/src/models/user.dart';

class Entity {
  final int id;
  final String name;
  final EntityType type;
  late final List<Entity>? permissions;
  late final List<Entity>? roles;
  late final List<User>? users;

  Entity({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    final entity = Entity(
      id: json['id'],
      name: json['name'],
      type: EntityType.values
          .firstWhere((e) => e.toString() == 'EntityType.${json['type']}'),
    );

    if (json['permissions'] != null) {
      entity.permissions =
          (json['permissions'] as List).map((e) => Entity.fromJson(e)).toList();
    }

    if (json['roles'] != null) {
      entity.roles =
          (json['roles'] as List).map((e) => Entity.fromJson(e)).toList();
    }

    return entity;
  }
}
