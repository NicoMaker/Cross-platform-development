class Auth {
  final String email;
  const Auth({required this.email});
}

class AppUser {
  final String email;
  final String username;

  const AppUser({
    required this.email,
    required this.username,
  });

  factory AppUser.fromEmail(String email) {
    return AppUser(email: email, username: email);
  }

  AppUser copyWith({
    String? email,
    String? username,
  }) {
    return AppUser(
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }
}
