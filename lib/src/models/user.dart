class User {
  final int id;
  final String email;
  final String name;
  final List<String> permissions;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
