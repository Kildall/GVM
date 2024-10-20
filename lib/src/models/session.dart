import 'package:gvm_flutter/src/models/user.dart';

class Session {
  final String id;
  final String ip;
  final String userAgent;
  final bool active;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int? userId;
  late final User? user;

  Session({
    required this.id,
    required this.ip,
    required this.userAgent,
    required this.active,
    required this.createdAt,
    required this.expiresAt,
    this.userId,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    final session = Session(
      id: json['id'],
      ip: json['ip'],
      userAgent: json['userAgent'],
      active: json['active'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      userId: json['userId'],
    );

    if (json['user'] != null) {
      session.user = User.fromJson(json['user']);
    }

    return session;
  }
}
