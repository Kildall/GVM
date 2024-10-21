//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'model_base.dart';
import 'audit_action.dart';
import 'user.dart';

class Audit implements ToJson, Id {
  @override
  int? id;
  DateTime? timestamp;
  AuditAction? action;
  String? entityType;
  int? userId;
  User? user;
  Map<String, dynamic>? data;
  String? description;

  Audit({
    this.id,
    this.timestamp,
    this.action,
    this.entityType,
    this.userId,
    this.user,
    this.data,
    this.description,
  });

  factory Audit.fromJson(Map<String, dynamic> json) => Audit(
      id: json['id'] as int?,
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
      action: AuditAction.values.byName(json['action']),
      entityType: json['entityType'] as String?,
      userId: json['userId'] as int?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      data: json['data'] as Map<String, dynamic>?,
      description: json['description'] as String?);

  Audit copyWith({
    int? id,
    DateTime? timestamp,
    AuditAction? action,
    String? entityType,
    int? userId,
    User? user,
    Map<String, dynamic>? data,
    String? description,
  }) {
    return Audit(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        action: action ?? this.action,
        entityType: entityType ?? this.entityType,
        userId: userId ?? this.userId,
        user: user ?? this.user,
        data: data ?? this.data,
        description: description ?? this.description);
  }

  Audit copyWithInstance(Audit audit) {
    return Audit(
        id: audit.id ?? id,
        timestamp: audit.timestamp ?? timestamp,
        action: audit.action ?? action,
        entityType: audit.entityType ?? entityType,
        userId: audit.userId ?? userId,
        user: audit.user ?? user,
        data: audit.data ?? data,
        description: audit.description ?? description);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (timestamp != null) 'timestamp': timestamp,
        if (action != null) 'action': action,
        if (entityType != null) 'entityType': entityType,
        if (userId != null) 'userId': userId,
        if (user != null) 'user': user,
        if (data != null) 'data': data,
        if (description != null) 'description': description
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Audit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          timestamp == other.timestamp &&
          action == other.action &&
          entityType == other.entityType &&
          userId == other.userId &&
          user == other.user &&
          data == other.data &&
          description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^
      timestamp.hashCode ^
      action.hashCode ^
      entityType.hashCode ^
      userId.hashCode ^
      user.hashCode ^
      data.hashCode ^
      description.hashCode;
}
