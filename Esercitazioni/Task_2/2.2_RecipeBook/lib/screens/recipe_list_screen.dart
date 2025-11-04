import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../screens/reciper_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final List<Recipe> _recipes = [
    Recipe(
      title: 'Pasta al Pomodoro',
      ingredients: ['Pasta', 'Pomodoro', 'Olio', 'Sale'],
      steps: ['Bollire acqua', 'Cuocere pasta', 'Aggiungere sugo'],
      url: 'https://www.google.com/search?q=pasta+al+pomodoro',
    ),
  ];

  void _addRecipe() {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    final ingredientsController = TextEditingController();
    final stepsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aggiungi Ricetta'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titolo Ricetta'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'Link URL'),
              ),
              TextField(
                controller: ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredienti (separa con una virgola)',
                ),
              ),
              TextField(
                controller: stepsController,
                decoration: const InputDecoration(
                  labelText: 'Step (separa con una virgola)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _recipes.add(
                  Recipe(
                    title: titleController.text,
                    url: urlController.text,
                    ingredients: ingredientsController.text.split(','),
                    steps: stepsController.text.split(','),
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Salva ed esci'),
          ),
        ],
      ),
    );
  }

  void _openRecipe(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Book')),
      body: ListView.builder(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final recipe = _recipes[index];
          return ListTile(
            title: Text(recipe.title),
            trailing: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () {
                _openRecipe(recipe);
              },
            ),
            onTap: () => _openRecipe(recipe),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }
}
