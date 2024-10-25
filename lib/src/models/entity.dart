//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'entity_type.dart';
import 'model_base.dart';
import 'user.dart';

class Entity implements ToJson, Id {
  @override
  int? id;
  String? name;
  EntityType? type;
  List<User>? users;
  List<Entity>? permissions;
  List<Entity>? roles;
  int? $usersCount;
  int? $permissionsCount;
  int? $rolesCount;

  Entity({
    this.id,
    this.name,
    this.type,
    this.users,
    this.permissions,
    this.roles,
    this.$usersCount,
    this.$permissionsCount,
    this.$rolesCount,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: EntityType.values.byName(json['type']),
      users: json['users'] != null
          ? createModels<User>(json['users'], User.fromJson)
          : null,
      permissions: json['permissions'] != null
          ? createModels<Entity>(json['permissions'], Entity.fromJson)
          : null,
      roles: json['roles'] != null
          ? createModels<Entity>(json['roles'], Entity.fromJson)
          : null,
      $usersCount: json['_count']?['users'] as int?,
      $permissionsCount: json['_count']?['permissions'] as int?,
      $rolesCount: json['_count']?['roles'] as int?);

  Entity copyWith({
    int? id,
    String? name,
    EntityType? type,
    List<User>? users,
    List<Entity>? permissions,
    List<Entity>? roles,
    int? $usersCount,
    int? $permissionsCount,
    int? $rolesCount,
  }) {
    return Entity(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        users: users ?? this.users,
        permissions: permissions ?? this.permissions,
        roles: roles ?? this.roles,
        $usersCount: $usersCount ?? this.$usersCount,
        $permissionsCount: $permissionsCount ?? this.$permissionsCount,
        $rolesCount: $rolesCount ?? this.$rolesCount);
  }

  Entity copyWithInstance(Entity entity) {
    return Entity(
        id: entity.id ?? id,
        name: entity.name ?? name,
        type: entity.type ?? type,
        users: entity.users ?? users,
        permissions: entity.permissions ?? permissions,
        roles: entity.roles ?? roles,
        $usersCount: entity.$usersCount ?? $usersCount,
        $permissionsCount: entity.$permissionsCount ?? $permissionsCount,
        $rolesCount: entity.$rolesCount ?? $rolesCount);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (type != null) 'type': type!.name,
        if (users != null)
          'users': users?.map((item) => item.toJson()).toList(),
        if (permissions != null)
          'permissions': permissions?.map((item) => item.toJson()).toList(),
        if (roles != null)
          'roles': roles?.map((item) => item.toJson()).toList(),
        if ($usersCount != null ||
            $permissionsCount != null ||
            $rolesCount != null)
          '_count': {
            if ($usersCount != null) 'users': $usersCount,
            if ($permissionsCount != null) 'permissions': $permissionsCount,
            if ($rolesCount != null) 'roles': $rolesCount,
          },
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          areListsEqual(users, other.users) &&
          areListsEqual(permissions, other.permissions) &&
          areListsEqual(roles, other.roles) &&
          $usersCount == other.$usersCount &&
          $permissionsCount == other.$permissionsCount &&
          $rolesCount == other.$rolesCount;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      users.hashCode ^
      permissions.hashCode ^
      roles.hashCode ^
      $usersCount.hashCode ^
      $permissionsCount.hashCode ^
      $rolesCount.hashCode;
}
