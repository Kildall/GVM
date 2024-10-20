import 'package:gvm_flutter/src/models/audit.dart';
import 'package:gvm_flutter/src/models/entity.dart';
import 'package:gvm_flutter/src/models/session.dart';
import 'package:gvm_flutter/src/models/signature.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final bool enabled;
  final bool verified;

  late final List<Session>? sessions;
  late final List<Entity>? permissions;
  late final List<Signature>? signatures;
  late final List<Audit>? audits;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.enabled = true,
    this.verified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      enabled: json['enabled'],
      verified: json['verified'],
    );

    if (json['sessions'] != null) {
      user.sessions =
          (json['sessions'] as List).map((e) => Session.fromJson(e)).toList();
    }

    if (json['permissions'] != null) {
      user.permissions =
          (json['permissions'] as List).map((e) => Entity.fromJson(e)).toList();
    }

    if (json['signatures'] != null) {
      user.signatures = (json['signatures'] as List)
          .map((e) => Signature.fromJson(e))
          .toList();
    }

    if (json['audits'] != null) {
      user.audits =
          (json['audits'] as List).map((e) => Audit.fromJson(e)).toList();
    }

    return user;
  }
}
