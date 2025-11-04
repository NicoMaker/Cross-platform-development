import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  void _openUrl() async {
    final uri = Uri.parse(recipe.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ingredienti:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...recipe.ingredients.map((item) => Text('- $item')),
              const SizedBox(height: 20),
              const Text(
                'Steps:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...recipe.steps.map((item) => Text('- $item')),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _openUrl,
                icon: const Icon(Icons.search),
                label: const Text('Vai su Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
