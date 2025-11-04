import 'package:flutter/material.dart';

// Un modello per rappresentare un singolo todo
class Todo {
  String title;
  bool completed;

  Todo({required this.title, this.completed = false});
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> _todoList = [];
  final TextEditingController _textFieldController = TextEditingController();
  int _selectedIndex = 0; // 0: Tutte, 1: Da Fare, 2: Completate

  void _addTodoItem(String title) {
    setState(() {
      _todoList.add(Todo(title: title));
    });
    _textFieldController.clear();
  }

  void _removeTodoItem(int index) {
    // Bisogna trovare l'indice corretto nella lista originale
    final todoToRemove = _getFilteredList()[index];
    setState(() {
      _todoList.remove(todoToRemove);
    });
  }

  void _toggleTodoStatus(int index, bool? value) {
    // Bisogna trovare l'indice corretto nella lista originale
    final todoToToggle = _getFilteredList()[index];
    final originalIndex = _todoList.indexOf(todoToToggle);
    setState(() {
      _todoList[originalIndex].completed = value ?? false;
    });
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // l'utente deve premere un pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aggiungi un nuovo todo'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
              hintText: 'Scrivi qui il tuo todo',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
                _textFieldController.clear();
              },
            ),
            TextButton(
              child: const Text('Aggiungi'),
              onPressed: () {
                if (_textFieldController.text.isNotEmpty) {
                  _addTodoItem(_textFieldController.text);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Todo> _getFilteredList() {
    switch (_selectedIndex) {
      case 1: // Da Fare
        return _todoList.where((todo) => !todo.completed).toList();
      case 2: // Completate
        return _todoList.where((todo) => todo.completed).toList();
      case 0: // Tutte
      default:
        return _todoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _getFilteredList();

    return Scaffold(
      appBar: AppBar(title: const Text('To Do List')),
      body: Column(
        children: [
          SegmentedButton<int>(
            segments: const <ButtonSegment<int>>[
              ButtonSegment<int>(value: 0, label: Text('Tutte')),
              ButtonSegment<int>(value: 1, label: Text('Da Fare')),
              ButtonSegment<int>(value: 2, label: Text('Completate')),
            ],
            selected: {_selectedIndex},
            onSelectionChanged: (Set<int> newSelection) {
              setState(() {
                _selectedIndex = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _todoList.isEmpty
                ? const Center(
                    child: Text('Aggiungi un todo per vederne le info.'),
                  )
                : filteredList.isEmpty
                ? const Center(child: Text('Nessun elemento in questa vista.'))
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final todo = filteredList[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.completed,
                          onChanged: (bool? value) {
                            _toggleTodoStatus(index, value);
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeTodoItem(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Aggiungi Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
