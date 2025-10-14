import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern TODO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const TodoHomePage(),
    );
  }
}

class Todo {
  String title;
  bool isCompleted;
  DateTime createdAt;

  Todo({
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Todo> _todos = [];
  final TextEditingController _textController = TextEditingController();

  int get _completedCount => _todos.where((t) => t.isCompleted).length;
  int get _activeCount => _todos.length - _completedCount;
  bool get _allCompleted => _todos.isNotEmpty && _todos.every((t) => t.isCompleted);

  void _addTodo() {
    if (_textController.text.trim().isEmpty) return;
    
    setState(() {
      _todos.insert(0, Todo(title: _textController.text.trim()));
      _textController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✓ Task aggiunto con successo'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _editTodo(int index) async {
    final TextEditingController editController = 
        TextEditingController(text: _todos[index].title);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.edit_rounded, size: 48),
        title: const Text('Modifica task'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nuovo nome',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULLA'),
          ),
          FilledButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                Navigator.pop(context, editController.text.trim());
              }
            },
            child: const Text('SALVA'),
          ),
        ],
      ),
    );

    if (result != null && result != _todos[index].title) {
      setState(() => _todos[index].title = result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✏️ Task modificato'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
    editController.dispose();
  }

  void _toggleTodo(int index, bool? value) {
    if (value == null) return;
    setState(() => _todos[index].isCompleted = value);
  }

  void _deleteTodo(int index) {
    final todo = _todos[index];
    setState(() => _todos.removeAt(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${todo.title}" eliminato'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'ANNULLA',
          onPressed: () => setState(() => _todos.insert(index, todo)),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_outline, size: 48, color: Colors.red),
        title: const Text('Elimina task'),
        content: Text('Vuoi davvero eliminare "${_todos[index].title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ANNULLA'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ELIMINA'),
          ),
        ],
      ),
    );

    if (confirm == true) _deleteTodo(index);
  }

  Future<void> _resetAll() async {
    if (_todos.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
        title: const Text('Reset completo'),
        content: Text('Eliminare tutti i ${_todos.length} task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ANNULLA'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('RESET'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _todos.clear());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🗑️ Tutti i task sono stati eliminati'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void _invertAll() {
    if (_todos.isEmpty) return;
    setState(() {
      for (final todo in _todos) {
        todo.isCompleted = !todo.isCompleted;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('↕️ Stati invertiti'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _toggleAll() {
    if (_todos.isEmpty) return;
    setState(() {
      final allChecked = _todos.every((t) => t.isCompleted);
      for (final todo in _todos) {
        todo.isCompleted = !allChecked;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_todos.every((t) => t.isCompleted) 
            ? '✓ Tutti i task completati' 
            : '○ Tutti i task da completare'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.3),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Text('TODO List', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Statistiche
          if (_todos.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.secondaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatCard(
                    icon: Icons.list_alt_rounded,
                    label: 'Totali',
                    value: _todos.length.toString(),
                    color: colorScheme.primary,
                  ),
                  _StatCard(
                    icon: Icons.check_circle_rounded,
                    label: 'Completati',
                    value: _completedCount.toString(),
                    color: Colors.green,
                  ),
                  _StatCard(
                    icon: Icons.pending_actions_rounded,
                    label: 'Attivi',
                    value: _activeCount.toString(),
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

          // Barra azioni
          if (_todos.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.swap_vert_rounded,
                      label: 'Inverti',
                      onPressed: _invertAll,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      icon: _allCompleted
                          ? Icons.check_box_outline_blank_rounded
                          : Icons.check_box_rounded,
                      label: _allCompleted ? 'Deseleziona' : 'Seleziona',
                      onPressed: _toggleAll,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.delete_sweep_rounded,
                      label: 'Reset',
                      onPressed: _resetAll,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

          // Input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.add_task_rounded, color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Aggiungi un nuovo task...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _addTodo(),
                      ),
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.add_rounded),
                      onPressed: _addTodo,
                      tooltip: 'Aggiungi',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Lista TODO
          Expanded(
            child: _todos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt_rounded,
                          size: 100,
                          color: colorScheme.primary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Nessun task presente',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aggiungi il tuo primo task per iniziare! 🚀',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return Dismissible(
                        key: ValueKey(todo.createdAt),
                        background: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_rounded, color: Colors.white, size: 28),
                              SizedBox(height: 4),
                              Text(
                                'Elimina',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) => _showDeleteConfirmation(index).then((_) => false),
                        child: Card(
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: todo.isCompleted 
                                  ? Colors.green.withOpacity(0.3)
                                  : colorScheme.outlineVariant,
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            leading: Checkbox(
                              value: todo.isCompleted,
                              onChanged: (value) => _toggleTodo(index, value),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                decoration: todo.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: todo.isCompleted
                                    ? colorScheme.onSurface.withOpacity(0.5)
                                    : null,
                                fontWeight: todo.isCompleted
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded),
                                  onPressed: () => _editTodo(index),
                                  color: Colors.blue.shade600,
                                  tooltip: 'Modifica',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded),
                                  onPressed: () => _showDeleteConfirmation(index),
                                  color: Colors.red.shade400,
                                  tooltip: 'Elimina',
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: color.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: color.withOpacity(0.15),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}