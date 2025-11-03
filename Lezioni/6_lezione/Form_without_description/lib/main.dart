import 'package:flutter/material.dart';
import 'package:its_aa_pn_2025_cross_platform/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyHomePage(title: 'TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _list = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _list.clear();
              });
            },
            label: const Text('Reset All'),
          ),
          SizedBox(width: 8),
          ElevatedButton.icon(
            icon: Icon(Icons.invert_colors),
            onPressed: () {
              setState(() {
                for (var i = 0; i < _list.length; i++) {
                  _list[i].isDone = !_list[i].isDone;
                }
              });
            },
            label: const Text('Invert All'),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            if (_list.isEmpty) //
              Text("non c'è niente"),
            for (final (i, todo) in _list.indexed)
              CheckboxListTile(
                value: todo.isDone,
                title: Text(todo.title),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _list[i].isDone = value;
                  });
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTodo,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _createTodo() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AddTodoFormDialog();
      },
    );

    if (result == null) return; // significa che il dialog è stato
    final newTodo = Todo(createdAt: DateTime.now(), title: result);
    setState(() {
      _list.add(newTodo);
    });
  }
}

class AddTodoFormDialog extends StatefulWidget {
  const AddTodoFormDialog({super.key});

  @override
  State<AddTodoFormDialog> createState() => _AddTodoFormDialogState();
}

class _AddTodoFormDialogState extends State<AddTodoFormDialog> {
  String? _text;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Text("inserisci qui il titolo"),
          TextField(
            decoration: InputDecoration(
              hintText: "inserisci almeno 3 caratteri",
            ),
            onChanged: (value) {
              _text = value;
            },
          ),
          ElevatedButton(
            onPressed: () {
              print(_text);
              if (_text == null) return;
              if (_text!.isEmpty) return;
              if (_text!.length < 3) return;
              Navigator.pop(context, _text);
            },
            child: Text("salva!"),
          ),
        ],
      ),
    );
  }
}
