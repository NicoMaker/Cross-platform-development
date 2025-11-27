import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 100),
            const SizedBox(height: 20),
            const Text(
              'Benvenuto nella Home!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/settings');
              },
              icon: const Icon(Icons.settings),
              label: const Text('Vai alle Impostazioni'),
            ),
          ],
        ),
      ),
    );
  }
}