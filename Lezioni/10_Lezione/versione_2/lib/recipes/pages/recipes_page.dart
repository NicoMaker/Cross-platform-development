import "package:flutter/material.dart";
import "package:its_aa_pn_2025_cross_platform/recipes/models/recipe.dart";
import "package:url_launcher/url_launcher.dart";

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("recipes"),
      ),
      body: ListView(
        children: [
          for (final recipe in recipes)
            ListTile(
              onTap: () {
                onTap(recipe);
              },
              title: Text(recipe.title),
              trailing: const Icon(Icons.chevron_right),
            ),
        ],
      ),
    );
  }

  Future<void> onTap(Recipe recipe) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: Text(recipe.title),
              actions: [
                IconButton(
                  onPressed: () {
                    viewLink(recipe.url);
                  },
                  icon: const Icon(Icons.link),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("ingredienti:"),
                for (final ingredient in recipe.ingredients) //
                  Text(ingredient),
                const Text("istruzioni:"),
                for (final step in recipe.steps) //
                  Text(step),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> viewLink(String url) async {
    final uri = Uri.parse(url);
    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) await launchUrl(uri);
  }
}

final recipes = [
  Recipe(
    title: "pastasciutta al ragù d'abruzzo",
    ingredients: ["voglia di vivere"],
    steps: ["1. evitare il balcone", "2. respirare piano"],
    url: "https://blog.giallozafferano.it/loscrignodelbuongusto/tagliatelle-al-ragu/",
  ),
  Recipe(
    title: "tonno scottato alla sticazzi",
    ingredients: ["voglia di esistere"],
    steps: ["1. mercato del pesce", "2. tanti soldi", "3. tanta buona volontà"],
    url: "https://blog.giallozafferano.it/loscrignodelbuongusto/tagliatelle-al-ragu/",
  ),
  Recipe(
    title: "il frico",
    ingredients: ["voglia di onto"],
    steps: ["1. friulanità"],
    url: "https://blog.giallozafferano.it/loscrignodelbuongusto/tagliatelle-al-ragu/",
  ),
];
