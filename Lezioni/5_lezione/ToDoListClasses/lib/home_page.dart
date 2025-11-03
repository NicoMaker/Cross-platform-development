import 'package:flutter/material.dart';
import 'package:its_aa_pn_2025_cross_platform/ToDo.dart';
import 'package:its_aa_pn_2025_cross_platform/edit_todo_dialog.dart';
import 'package:its_aa_pn_2025_cross_platform/todo_list_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Todo> _todos = [];

  Future<void> _addTodo() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showDialog<Todo>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New TODO'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Description', alignLabelWithHint: true),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final description = descriptionController.text;
                  Navigator.of(context).pop(Todo(
                      title: titleController.text,
                      description: description.isNotEmpty ? description : null,
                      date: DateTime.now()));
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null) setState(() => _todos.add(result));
  }

  Future<void> _editTodo(int index) async {
    final todoToEdit = _todos[index];
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) => EditTodoDialog(todo: todoToEdit),
    );

    if (result != null) {
      setState(() {
        _todos[index] = result;
      });
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleTodo(int index, bool? value) {
    setState(() {
      if (value == null) return;
      _todos[index].isCompleted = value;
    });
  }

  Future<void> _deleteAllTodos() async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina tutto'),
        content: const Text('Sei sicuro di voler eliminare tutti i task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Elimina'),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );

    if (confirmDelete == true) setState(() => _todos.clear());
  }

  void _invertAll() {
    setState(() {
      for (int i = 0; i < _todos.length; i++) {
        _todos[i].isCompleted = !_todos[i].isCompleted;
      }
    });
  }

  void _toggleAllActive() {
    if (_todos.isEmpty) return;
    setState(() {
      final bool allChecked = _todos.every((todo) => todo.isCompleted);
      final newValue = !allChecked;
      for (final todo in _todos) {
        todo.isCompleted = newValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool areAllCompleted =
        _todos.isNotEmpty && _todos.every((todo) => todo.isCompleted);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          if (_todos.isNotEmpty) ...[
            IconButton(
              icon: Icon(areAllCompleted
                  ? Icons.check_box_outline_blank
                  : Icons.check_box),
              tooltip: areAllCompleted ? 'Seleziona tutti non completati' : 'Seleziona tutti completati',
              onPressed: _toggleAllActive,
            ),
            IconButton(
              icon: const Icon(Icons.invert_colors),
              tooltip: 'Invert All',
              onPressed: _invertAll,
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever_outlined),
              tooltip: 'Elimina tutto',
              onPressed: _deleteAllTodos,
            ),
          ]
        ],
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                'Nessun task presente.\nAggiungine uno nuovo!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : LayoutBuilder(builder: (context, constraints) {
              const crossAxisCount = 3;
              const spacing = 8.0;
              final itemWidth =
                  (constraints.maxWidth - (spacing * (crossAxisCount + 1))) /
                      crossAxisCount;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(spacing),
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: List.generate(_todos.length, (index) {
                    final todo = _todos[index];
                    return SizedBox(
                      width: itemWidth,
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: TodoListItem(
                          todo: todo,
                          onChanged: (value) => _toggleTodo(index, value),
                          onEdit: () => _editTodo(index),
                          onDelete: () => _deleteTodo(index),
                        ),
                      ),
                    );
                  }),
                  ),
              );
            }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}