class LoginResponse {
  final DateTime expires;
  final String token;
  final bool verified;

  LoginResponse({
    required this.expires,
    required this.token,
    required this.verified,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      expires: DateTime.parse(json['expires']),
      token: json['token'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expires': expires.toIso8601String(),
      'token': token,
      'verified': verified,
    };
  }
}

class VerifyTokenResponse {
  final bool valid;

  VerifyTokenResponse({required this.valid});

  factory VerifyTokenResponse.fromJson(Map<String, dynamic> json) {
    return VerifyTokenResponse(
      valid: json['valid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
    };
  }
}
