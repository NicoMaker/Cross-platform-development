import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/form.dart";
import "package:its_aa_pn_2025_cross_platform/todo.dart";
import "package:its_aa_pn_2025_cross_platform/todo_list.dart";

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TODO App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
        ),
      ),
      home: const MyHomePage(title: "TODO"),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: clear,
            label: const Text("Reset All"),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.invert_colors),
            onPressed: invertAll,
            label: const Text("Invert All"),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            if (list.isEmpty) //
              const Text("non c'è niente"),
            for (final (i, todo) in list.indexed)
              CheckboxListTile(
                value: todo.isDone,
                title: Text(todo.title),
                subtitle: Text(todo.description),
                onChanged: (value) {
                  onChecked(i, value: value);
                },
              ),

            Expanded(
              child: Column(
                children: [
                  const Text("titolo"),
                  ElevatedButton.icon(
                    onPressed: () {
                      print("pippo");
                    },
                    label: const Text("premimi ora per un aghio!"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTodo,
        child: const Icon(Icons.add),
      ),
    );
  }

  void onChecked(int index, {bool? value}) {
    ref.read(todoListProvider.notifier).checkElement(index, value: value);
  }

  void invertAll() {
    ref.read(todoListProvider.notifier).invertAll();
  }

  void clear() {
    ref.read(todoListProvider.notifier).reset();
  }

  Future<void> createTodo() async {
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) {
        return const AddTodoFormDialog();
      },
    );

    if (result == null) return; // significa che il dialog è stato annullato

    ref.read(todoListProvider.notifier).addTodo(result);
  }
}

String f() {
  return [1, 2, 3]
      .map((e) => e * 2)
      .map((e) => e ~/ 3)
      .where((element) => element.isEven)
      .map((e) => "something something")
      .expand((element) => element.split(" "))
      .join("-");
}
