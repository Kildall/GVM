class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final bool enabled;
  final bool verified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.enabled = true,
    this.verified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      enabled: json['enabled'],
      verified: json['verified'],
    );
  }
}
