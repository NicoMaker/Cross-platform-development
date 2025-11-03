import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

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

// Definiamo un modello per i nostri dati "TODO".
// Ogni oggetto Todo avrà un titolo e uno stato di completamento.
class Todo {
  String title;
  bool isCompleted;

  Todo({required this.title, this.isCompleted = false});
}

class _MyHomePageState extends State<MyHomePage> {
  // Modifichiamo lo stato per usare una lista di oggetti Todo.
  final List<Todo> _todos = [];

  // Funzione per aggiungere un nuovo elemento "TODO" alla lista.
  // Mostra un dialogo per inserire il titolo e lo stato iniziale.
  Future<void> _addTodo() async {
    final TextEditingController textController = TextEditingController();
    bool isCompleted = false;

    final result = await showDialog<Todo>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New TODO'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'TODO Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  Navigator.of(context).pop(Todo(title: textController.text));
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

  // Funzione per invertire lo stato di una singola checkbox.
  void _toggleTodo(int index, bool? value) {
    setState(() {
      // Aggiorniamo il valore della checkbox all'indice specificato.
      if (value == null) return;
      _todos[index].isCompleted = value;
    });
  }

  // Funzione per resettare tutti i task, svuotando la lista.
  void _resetAll() => setState(() => _todos.clear());

  // Funzione per invertire lo stato di tutti i task.
  void _invertAll() {
    setState(() {
      for (int i = 0; i < _todos.length; i++) {
        _todos[i].isCompleted = !_todos[i].isCompleted;
      }
    });
  }

  // Funzione per impostare tutti i task come completati o non completati.
  // Se sono tutti già completati, li imposta tutti come non completati.
  // Altrimenti, li imposta tutti come completati.
  void _toggleAllActive() {
    if (_todos.isEmpty) return;
    setState(() {
      // Controlla se tutti gli elementi sono 'true'.
      final bool allChecked = _todos.every((todo) => todo.isCompleted);
      // Imposta tutti gli elementi al valore opposto di 'allChecked'.
      // Se tutti erano spuntati, diventano tutti non spuntati, e viceversa.
      final newValue = !allChecked;
      for (final todo in _todos) {
        todo.isCompleted = newValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            // Chiama la funzione per resettare lo stato.
            onPressed: _resetAll,
            label: const Text('Reset All'),
          ),
          SizedBox(width: 40),
          ElevatedButton.icon(
            icon: Icon(Icons.invert_colors),
            // Chiama la funzione per invertire lo stato di tutti i task.
            onPressed: _invertAll,
            label: const Text('Invert All'),
          ),
          SizedBox(width: 40),
          ElevatedButton.icon(
            icon: Icon(Icons.check_box),
            // Chiama la funzione per spuntare/deselezionare tutti i task
            onPressed: _toggleAllActive,
            label: const Text('Toggle All/NONE'),
          ),
          SizedBox(width: 40),
        ],
      ),
      // Usiamo ListView.builder per creare una lista scorrevole in modo efficiente.
      // Costruisce solo gli elementi che sono attualmente visibili sullo schermo.
      body: ListView.builder(
        // Il numero di elementi nella lista è la lunghezza del nostro stato `_todos`.
        itemCount: _todos.length,
        // `itemBuilder` è una funzione che viene chiamata per ogni elemento della lista.
        itemBuilder: (context, index) {
          // Per ogni elemento, creiamo un CheckboxListTile.
          final todo = _todos[index];
          return CheckboxListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            // Il valore della checkbox è preso dalla nostra lista di stato `_todos`.
            value: todo.isCompleted,
            // Quando la checkbox viene premuta, chiamiamo la funzione per invertire il suo stato.
            onChanged: (value) => _toggleTodo(index, value),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Quando il pulsante viene premuto, chiamiamo la funzione per aggiungere un nuovo task.
        onPressed: _addTodo,
        child: Icon(Icons.add),
      ),
    );
  }
}
