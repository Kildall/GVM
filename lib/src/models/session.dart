class Session {
  final String id;
  final String ip;
  final String userAgent;
  final bool active;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int? userId;

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
    return Session(
      id: json['id'],
      ip: json['ip'],
      userAgent: json['userAgent'],
      active: json['active'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      userId: json['userId'],
    );
  }
}
