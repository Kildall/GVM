import 'package:gvm_flutter/src/models/enums.dart';
import 'package:gvm_flutter/src/models/user.dart';

class Signature {
  final String id;
  final AccountAction action;
  final String? userAgent;
  final String? ip;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int userId;
  late final User? user;

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
    final signature = Signature(
      id: json['id'],
      action: AccountAction.values
          .firstWhere((e) => e.toString() == 'AccountAction.${json['action']}'),
      userAgent: json['userAgent'],
      ip: json['ip'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      userId: json['userId'],
    );

    if (json['user'] != null) {
      signature.user = User.fromJson(json['user']);
    }

    return signature;
  }
}
