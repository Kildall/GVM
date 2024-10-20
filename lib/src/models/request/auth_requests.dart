class LoginRequest {
  final String email;
  final String password;
  final bool remember;

  LoginRequest(
      {required this.email, required this.password, this.remember = false});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'remember': remember,
      };
}

class SignupRequest {
  final String email;
  final String password;
  final String name;

  SignupRequest(
      {required this.email, required this.password, required this.name});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'name': name,
      };
}
