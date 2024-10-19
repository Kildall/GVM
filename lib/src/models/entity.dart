import 'package:gvm_flutter/src/models/enums.dart';

class Entity {
  final int id;
  final String name;
  final EntityType type;

  Entity({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['id'],
      name: json['name'],
      type: EntityType.values
          .firstWhere((e) => e.toString() == 'EntityType.${json['type']}'),
    );
  }
}
