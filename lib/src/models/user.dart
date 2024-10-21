//***  AUTO-GENERATED FILE - DO NOT MODIFY ***//

import 'model_base.dart';
import 'session.dart';
import 'entity.dart';
import 'signature.dart';
import 'audit.dart';
import 'employee.dart';

class User implements ToJson, Id {
  @override
  int? id;
  String? email;
  String? password;
  bool? enabled;
  bool? verified;
  List<Session>? sessions;
  List<Entity>? permissions;
  List<Signature>? signatures;
  List<Audit>? audits;
  Employee? employee;
  int? employeeId;
  int? $sessionsCount;
  int? $permissionsCount;
  int? $signaturesCount;
  int? $auditsCount;

  User({
    this.id,
    this.email,
    this.password,
    this.enabled = true,
    this.verified = false,
    this.sessions,
    this.permissions,
    this.signatures,
    this.audits,
    this.employee,
    this.employeeId,
    this.$sessionsCount,
    this.$permissionsCount,
    this.$signaturesCount,
    this.$auditsCount,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      enabled: json['enabled'] as bool?,
      verified: json['verified'] as bool?,
      sessions: json['sessions'] != null
          ? createModels<Session>(json['sessions'], Session.fromJson)
          : null,
      permissions: json['permissions'] != null
          ? createModels<Entity>(json['permissions'], Entity.fromJson)
          : null,
      signatures: json['signatures'] != null
          ? createModels<Signature>(json['signatures'], Signature.fromJson)
          : null,
      audits: json['audits'] != null
          ? createModels<Audit>(json['audits'], Audit.fromJson)
          : null,
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
      employeeId: json['employeeId'] as int?,
      $sessionsCount: json['_count']?['sessions'] as int?,
      $permissionsCount: json['_count']?['permissions'] as int?,
      $signaturesCount: json['_count']?['signatures'] as int?,
      $auditsCount: json['_count']?['audits'] as int?);

  User copyWith({
    int? id,
    String? email,
    String? password,
    bool? enabled,
    bool? verified,
    List<Session>? sessions,
    List<Entity>? permissions,
    List<Signature>? signatures,
    List<Audit>? audits,
    Employee? employee,
    int? employeeId,
    int? $sessionsCount,
    int? $permissionsCount,
    int? $signaturesCount,
    int? $auditsCount,
  }) {
    return User(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        enabled: enabled ?? this.enabled,
        verified: verified ?? this.verified,
        sessions: sessions ?? this.sessions,
        permissions: permissions ?? this.permissions,
        signatures: signatures ?? this.signatures,
        audits: audits ?? this.audits,
        employee: employee ?? this.employee,
        employeeId: employeeId ?? this.employeeId,
        $sessionsCount: $sessionsCount ?? this.$sessionsCount,
        $permissionsCount: $permissionsCount ?? this.$permissionsCount,
        $signaturesCount: $signaturesCount ?? this.$signaturesCount,
        $auditsCount: $auditsCount ?? this.$auditsCount);
  }

  User copyWithInstance(User user) {
    return User(
        id: user.id ?? id,
        email: user.email ?? email,
        password: user.password ?? password,
        enabled: user.enabled ?? enabled,
        verified: user.verified ?? verified,
        sessions: user.sessions ?? sessions,
        permissions: user.permissions ?? permissions,
        signatures: user.signatures ?? signatures,
        audits: user.audits ?? audits,
        employee: user.employee ?? employee,
        employeeId: user.employeeId ?? employeeId,
        $sessionsCount: user.$sessionsCount ?? $sessionsCount,
        $permissionsCount: user.$permissionsCount ?? $permissionsCount,
        $signaturesCount: user.$signaturesCount ?? $signaturesCount,
        $auditsCount: user.$auditsCount ?? $auditsCount);
  }

  @override
  Map<String, dynamic> toJson() => ({
        if (id != null) 'id': id,
        if (email != null) 'email': email,
        if (password != null) 'password': password,
        if (enabled != null) 'enabled': enabled,
        if (verified != null) 'verified': verified,
        if (sessions != null)
          'sessions': sessions?.map((item) => item.toJson()).toList(),
        if (permissions != null)
          'permissions': permissions?.map((item) => item.toJson()).toList(),
        if (signatures != null)
          'signatures': signatures?.map((item) => item.toJson()).toList(),
        if (audits != null)
          'audits': audits?.map((item) => item.toJson()).toList(),
        if (employee != null) 'employee': employee,
        if (employeeId != null) 'employeeId': employeeId,
        if ($sessionsCount != null ||
            $permissionsCount != null ||
            $signaturesCount != null ||
            $auditsCount != null)
          '_count': {
            if ($sessionsCount != null) 'sessions': $sessionsCount,
            if ($permissionsCount != null) 'permissions': $permissionsCount,
            if ($signaturesCount != null) 'signatures': $signaturesCount,
            if ($auditsCount != null) 'audits': $auditsCount,
          },
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          password == other.password &&
          enabled == other.enabled &&
          verified == other.verified &&
          areListsEqual(sessions, other.sessions) &&
          areListsEqual(permissions, other.permissions) &&
          areListsEqual(signatures, other.signatures) &&
          areListsEqual(audits, other.audits) &&
          employee == other.employee &&
          employeeId == other.employeeId &&
          $sessionsCount == other.$sessionsCount &&
          $permissionsCount == other.$permissionsCount &&
          $signaturesCount == other.$signaturesCount &&
          $auditsCount == other.$auditsCount;

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      password.hashCode ^
      enabled.hashCode ^
      verified.hashCode ^
      sessions.hashCode ^
      permissions.hashCode ^
      signatures.hashCode ^
      audits.hashCode ^
      employee.hashCode ^
      employeeId.hashCode ^
      $sessionsCount.hashCode ^
      $permissionsCount.hashCode ^
      $signaturesCount.hashCode ^
      $auditsCount.hashCode;
}
