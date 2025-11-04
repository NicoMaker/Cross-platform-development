import 'package:flutter/material.dart';

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
  int _selectedIndex = 0;

  void _addTodoItem(String title) {
    setState(() {
      _todoList.add(Todo(title: title));
    });
    _textFieldController.clear();
  }

  void _removeTodoItem(int index) {
    final todoToRemove = _getFilteredList()[index];
    setState(() {
      _todoList.remove(todoToRemove);
    });
  }

  void _toggleTodoStatus(int index, bool? value) {
    final todoToToggle = _getFilteredList()[index];
    final originalIndex = _todoList.indexOf(todoToToggle);
    setState(() {
      _todoList[originalIndex].completed = value ?? false;
    });
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
      case 1: 
        return _todoList.where((todo) => !todo.completed).toList();
      case 2:
        return _todoList.where((todo) => todo.completed).toList();
      case 0:
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterButton(0, 'Tutte'),
              _buildFilterButton(1, 'Da Fare'),
              _buildFilterButton(2, 'Completate'),
            ],
          ),
          const Divider(color: Colors.black, height: 1),
          Expanded(
            child: _todoList.isEmpty
                ? const Center(
                    child: Text('Aggiungi un todo per vederne le info.'),
                  )
                : filteredList.isEmpty
                ? const Center(child: Text('Nessun elemento.'))
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final todo = filteredList[index];
                      return InkWell(
                        onLongPress: () => _removeTodoItem(index),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.completed,
                            onChanged: (bool? value) {
                              _toggleTodoStatus(index, value);
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              color: Colors.black,
                              decoration: todo.completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
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

  Widget _buildFilterButton(int index, String text) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
      ),
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          decoration: _selectedIndex == index
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
    );
  }
}
