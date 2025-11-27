import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppUser {
  final String email;
  final String username;

  const AppUser({
    required this.email,
    required this.username,
  });

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

class AuthNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() => null; // utente non loggato

  bool get isLoggedIn => state != null;

  void login({required String email, required String username}) {
    state = AppUser(email: email, username: username);
  }

  void logout() {
    state = null;
  }

  void updateUsername(String newUsername) {
    if (state == null) return;
    state = state!.copyWith(username: newUsername);
  }

  void updateEmail(String newEmail) {
    if (state == null) return;
    state = state!.copyWith(email: newEmail);
  }
}

final authProvider =
    NotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);
