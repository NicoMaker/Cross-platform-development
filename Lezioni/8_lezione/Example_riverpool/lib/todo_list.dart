import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/todo.dart";

final NotifierProvider<TodoList, List<Todo>> todoListProvider = NotifierProvider(
  TodoList.new,
);

class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [];
  }

  void addTodo(Todo todo) {
    state = [
      todo,
      ...state,
    ];
  }

  void reset() {
    state = [];
  }

  void invertAll() {
    for (var i = 0; i < state.length; i++) {
      state[i].isDone = !state[i].isDone;
    }
    ref.notifyListeners(); // equivalente di setState
  }

  void checkElement(int index, {bool? value}) {
    if (value == null) return;
    state[index].isDone = value;
    ref.notifyListeners();
  }
}
