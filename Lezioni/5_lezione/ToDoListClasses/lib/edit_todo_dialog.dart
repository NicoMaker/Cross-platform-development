import 'package:flutter/material.dart';
import 'package:its_aa_pn_2025_cross_platform/ToDo.dart';

class EditTodoDialog extends StatefulWidget {
  final Todo todo;
  const EditTodoDialog({super.key, required this.todo});

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController =
        TextEditingController(text: widget.todo.description);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit TODO'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
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
            if (_titleController.text.isNotEmpty) {
              final description = _descriptionController.text;
              final updatedTodo = widget.todo.copyWith(
                  title: _titleController.text,
                  description: description.isNotEmpty ? description : null);
              Navigator.of(context).pop(updatedTodo);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}