//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'package:gvm_flutter/src/models/exceptions/model_parse_exception.dart';

import 'model_base.dart';
import 'user.dart';

class Session implements ToJson, IdString {
  @override
  String? id;
  String? ip;
  String? userAgent;
  bool? active;
  DateTime? createdAt;
  DateTime? expiresAt;
  User? user;
  int? userId;

  Session({
    this.id,
    this.ip,
    this.userAgent,
    this.active,
    this.createdAt,
    this.expiresAt,
    this.user,
    this.userId,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    try {
      return Session(
          id: json['id'] as String?,
          ip: json['ip'] as String?,
          userAgent: json['userAgent'] as String?,
          active: json['active'] as bool?,
          createdAt: json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : null,
          expiresAt: json['expiresAt'] != null
              ? DateTime.parse(json['expiresAt'])
              : null,
          user: json['user'] != null
              ? User.fromJson(json['user'] as Map<String, dynamic>)
              : null,
          userId: json['userId'] as int?);
    } catch (e) {
      throw ModelParseException('Session', e.toString(), json, e);
    }
  }

  Session copyWith({
    String? id,
    String? ip,
    String? userAgent,
    bool? active,
    DateTime? createdAt,
    DateTime? expiresAt,
    User? user,
    int? userId,
  }) {
    return Session(
        id: id ?? this.id,
        ip: ip ?? this.ip,
        userAgent: userAgent ?? this.userAgent,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        expiresAt: expiresAt ?? this.expiresAt,
        user: user ?? this.user,
        userId: userId ?? this.userId);
  }

  Session copyWithInstance(Session session) {
    return Session(
        id: session.id ?? id,
        ip: session.ip ?? ip,
        userAgent: session.userAgent ?? userAgent,
        active: session.active ?? active,
        createdAt: session.createdAt ?? createdAt,
        expiresAt: session.expiresAt ?? expiresAt,
        user: session.user ?? user,
        userId: session.userId ?? userId);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (ip != null) 'ip': ip,
        if (userAgent != null) 'userAgent': userAgent,
        if (active != null) 'active': active,
        if (createdAt != null) 'createdAt': createdAt,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (user != null) 'user': user,
        if (userId != null) 'userId': userId
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Session &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ip == other.ip &&
          userAgent == other.userAgent &&
          active == other.active &&
          createdAt == other.createdAt &&
          expiresAt == other.expiresAt &&
          user == other.user &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      ip.hashCode ^
      userAgent.hashCode ^
      active.hashCode ^
      createdAt.hashCode ^
      expiresAt.hashCode ^
      user.hashCode ^
      userId.hashCode;
}
