import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/todo_riverpod/models/todo.dart";

final NotifierProvider<TodoListNotifier, List<Todo>> todoListProvider =
    NotifierProvider.autoDispose<TodoListNotifier, List<Todo>>(TodoListNotifier.new);

class TodoListNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [];
  }

  void addTodo(Map<String, Object?> json) {
    final title = json["title"]! as String;
    final description = json["description"]! as String;
    final todo = Todo(title: title, description: description);
    state.add(todo);
    ref.notifyListeners();
  }

  void changeTodo(int i, {required bool? value}) {
    state[i].completed = value!;
    ref.notifyListeners();
  }

  void updateTodo(int i, Map<String, Object?> json) {
    final title = json["title"]! as String;
    final description = json["description"]! as String;
    state[i].title = title;
    state[i].description = description;
    ref.notifyListeners();
  }
}
