class Todo {
  Todo({
    required this.title,
    required this.description,
    this.completed = false,
  });

  String title;
  String description;
  bool completed;
}
