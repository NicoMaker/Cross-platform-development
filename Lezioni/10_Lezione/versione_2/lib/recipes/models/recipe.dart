class Recipe {
  Recipe({
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.url,
  });
  String title;
  String url;
  List<String> ingredients;
  List<String> steps;
}
