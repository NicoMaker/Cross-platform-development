import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:its_aa_pn_2025_cross_platform/ToDo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> subtitleWidgets = [];
    if (todo.description != null && todo.description!.isNotEmpty) {
      subtitleWidgets.add(Text(todo.description!,
          maxLines: 2, overflow: TextOverflow.ellipsis));
    }
    if (todo.date != null) {
      subtitleWidgets.add(Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          DateFormat('dd MMMM yyyy, HH:mm', 'it_IT').format(todo.date!),
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
              Checkbox(
                value: todo.isCompleted,
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: subtitleWidgets,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Modifica',
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Elimina',
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}