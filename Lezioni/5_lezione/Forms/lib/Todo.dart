class Todo {
  Todo({
    required this.createdAt,
    required this.title,
    this.isDone = false,
    this.expiresAt,
  });
  bool isDone;
  String title;
  DateTime createdAt;
  DateTime? expiresAt;
}

void f() {
  final todo = Todo(
    createdAt: DateTime.now(),
    title: "un titolo",
    isDone: true,
    expiresAt: DateTime(2026, 01, 01),
  );
  print(todo.isDone); // false
}