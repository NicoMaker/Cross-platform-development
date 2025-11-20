import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/todo_riverpod/state/todo_list.dart";

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("MY TODO LIST"),
      ),
      body: ListView(
        children: [
          for (var i = 0; i < list.length; i++)
            ListTile(
              leading: Checkbox(
                value: list[i].completed,
                onChanged: (value) {
                  onChecked(i, value);
                },
              ),
              title: Text(list[i].title),
              subtitle: Text(list[i].description),
            ),
        ],
      ),
    );
  }

  void onChecked(int i, bool? value) {
    ref //
        .read(todoListProvider.notifier)
        .changeTodo(i, value);
  }
}
