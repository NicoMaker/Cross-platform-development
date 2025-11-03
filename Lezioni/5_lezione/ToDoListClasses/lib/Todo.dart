class Todo {
  String title;
  String? description;
  DateTime? date;
  bool isCompleted;

  Todo({
    required this.title,
    this.description,
    this.date,
    this.isCompleted = false,
  });

  Todo copyWith({
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
  }) {
    return Todo(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}