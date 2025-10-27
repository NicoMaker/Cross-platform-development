import 'package:flutter/material.dart';
import 'package:its_aa_pn_2025_cross_platform/form.dart';
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
                subtitle: Text(todo.description),
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
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) {
        return AddTodoFormDialog();
      },
    );

    if (result == null) return; // significa che il dialog è stato annullato

    setState(() {
      _list.add(result);
    });
  }
}