class Todo {
  Todo({
    required this.createdAt,
    required this.title,
    required this.description,
    this.isDone = false,
    this.expiresAt,
  });
  bool isDone;
  String title;
  String description;
  DateTime createdAt;
  DateTime? expiresAt;
}

void f() {
  final todo = Todo(
    createdAt: DateTime.now(),
    title: "UN POLLOOOOO",
    description: "fagiano",
    isDone: true,
    expiresAt: DateTime(2026),
  );
  print(todo.isDone); // false
}
