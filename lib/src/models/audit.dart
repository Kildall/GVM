import 'package:gvm_flutter/src/models/enums.dart';

class Audit {
  final int id;
  final DateTime timestamp;
  final AuditAction action;
  final String entityType;
  final int userId;
  final Map<String, dynamic>? data;
  final String? description;

  Audit({
    required this.id,
    required this.timestamp,
    required this.action,
    required this.entityType,
    required this.userId,
    this.data,
    this.description,
  });

  factory Audit.fromJson(Map<String, dynamic> json) {
    return Audit(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      action: AuditAction.values
          .firstWhere((e) => e.toString() == 'AuditAction.${json['action']}'),
      entityType: json['entityType'],
      userId: json['userId'],
      data: json['data'],
      description: json['description'],
    );
  }
}
