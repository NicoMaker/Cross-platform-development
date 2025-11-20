import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/todo_riverpod/models/todo.dart";

final NotifierProvider<TodoList, List<Todo>> todoListProvider =
    NotifierProvider.autoDispose<TodoList, List<Todo>>(
      TodoList.new,
    );

class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [];
  }

  void addTodo(String title, String description) {
    final todo = Todo(
      title: title,
      description: description,
    );
    state.add(todo);
    ref.notifyListeners();
  }

  void removeTodo(int i) {
    state.removeAt(i);
    ref.notifyListeners();
  }

  void changeTodo(int i, bool? value) {
    state[i].completed = value!;
    ref.notifyListeners();
  }

  void reset() {
    state = [];
  }

  void invert() {
    for (var i = 0; i < state.length; i++) {
      state[i].completed = !state[i].completed;
    }
  }
}
