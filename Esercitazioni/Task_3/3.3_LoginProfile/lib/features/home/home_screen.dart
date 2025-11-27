import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    final greeting =
        user == null ? 'Welcome, Guest!' : 'Welcome, ${user.username}!';

    void logout() {
      ref.read(authProvider.notifier).logout();
      context.go('/login');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.person),
          ),
          if (user != null)
            IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              greeting,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            if (user != null)
              ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text('Esci'),
              ),
          ],
        ),
      ),
    );
  }
}
