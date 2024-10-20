class AuthUser {
  final int id;
  final String email;
  final String name;
  final List<String> permissions;

  AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.permissions,
  });

  hasPermission(String permission) {
    return permission.contains(permission);
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      return AuthUser(
        id: json['user']['id'],
        email: json['user']['email'],
        name: json['user']['name'],
        permissions: List<String>.from(json['user']['permissions']),
      );
    }
    return AuthUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      permissions: List<String>.from(json['permissions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'permissions': permissions,
    };
  }
}
