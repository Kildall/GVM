import 'package:gvm_flutter/src/models/enums.dart';

class Signature {
  final String id;
  final AccountAction action;
  final String? userAgent;
  final String? ip;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int userId;

  Signature({
    required this.id,
    required this.action,
    this.userAgent,
    this.ip,
    required this.createdAt,
    required this.expiresAt,
    required this.userId,
  });

  factory Signature.fromJson(Map<String, dynamic> json) {
    return Signature(
      id: json['id'],
      action: AccountAction.values
          .firstWhere((e) => e.toString() == 'AccountAction.${json['action']}'),
      userAgent: json['userAgent'],
      ip: json['ip'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      userId: json['userId'],
    );
  }
}
