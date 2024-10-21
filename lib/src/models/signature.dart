//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'model_base.dart';
import 'account_action.dart';
import 'user.dart';

class Signature implements ToJson, IdString {
  @override
  String? id;
  AccountAction? action;
  String? userAgent;
  String? ip;
  DateTime? createdAt;
  DateTime? expiresAt;
  User? user;
  int? userId;

  Signature({
    this.id,
    this.action,
    this.userAgent,
    this.ip,
    this.createdAt,
    this.expiresAt,
    this.user,
    this.userId,
  });

  factory Signature.fromJson(Map<String, dynamic> json) => Signature(
      id: json['id'] as String?,
      action: AccountAction.values.byName(json['action']),
      userAgent: json['userAgent'] as String?,
      ip: json['ip'] as String?,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      expiresAt:
          json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      userId: json['userId'] as int?);

  Signature copyWith({
    String? id,
    AccountAction? action,
    String? userAgent,
    String? ip,
    DateTime? createdAt,
    DateTime? expiresAt,
    User? user,
    int? userId,
  }) {
    return Signature(
        id: id ?? this.id,
        action: action ?? this.action,
        userAgent: userAgent ?? this.userAgent,
        ip: ip ?? this.ip,
        createdAt: createdAt ?? this.createdAt,
        expiresAt: expiresAt ?? this.expiresAt,
        user: user ?? this.user,
        userId: userId ?? this.userId);
  }

  Signature copyWithInstance(Signature signature) {
    return Signature(
        id: signature.id ?? id,
        action: signature.action ?? action,
        userAgent: signature.userAgent ?? userAgent,
        ip: signature.ip ?? ip,
        createdAt: signature.createdAt ?? createdAt,
        expiresAt: signature.expiresAt ?? expiresAt,
        user: signature.user ?? user,
        userId: signature.userId ?? userId);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (action != null) 'action': action,
        if (userAgent != null) 'userAgent': userAgent,
        if (ip != null) 'ip': ip,
        if (createdAt != null) 'createdAt': createdAt,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (user != null) 'user': user,
        if (userId != null) 'userId': userId
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Signature &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          action == other.action &&
          userAgent == other.userAgent &&
          ip == other.ip &&
          createdAt == other.createdAt &&
          expiresAt == other.expiresAt &&
          user == other.user &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      action.hashCode ^
      userAgent.hashCode ^
      ip.hashCode ^
      createdAt.hashCode ^
      expiresAt.hashCode ^
      user.hashCode ^
      userId.hashCode;
}
