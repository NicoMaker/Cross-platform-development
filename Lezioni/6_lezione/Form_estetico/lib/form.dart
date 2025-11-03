import 'package:flutter/material.dart';
import 'package:its_aa_pn_2025_cross_platform/todo.dart';

class AddTodoFormDialog extends StatefulWidget {
  const AddTodoFormDialog({super.key});

  @override
  State<AddTodoFormDialog> createState() => _AddTodoFormDialogState();
}

class _AddTodoFormDialogState extends State<AddTodoFormDialog> {
  final _key = GlobalKey<FormState>();

  String? _title;
  String? _description;
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("nuovo todo!", style: theme.textTheme.headlineSmall),
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(hintText: "titolo..."),
                validator: (value) {
                  if (value == null) return "campo obbligatorio!";
                  if (value.isEmpty) return "campo obbligatorio!";
                  if (value.length < 3) return "inserisci almeno 3 caratteri";
                  return null;
                },
                onChanged: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "descrizione..."),
                validator: (value) {
                  if (value == null) return "campo obbligatorio";
                  if (value.isEmpty) return "campo obbligatorio!";
                  if (value.length < 20) return "inserisci almeno 20 caratteri";
                  return null;
                },
                onChanged: (value) {
                  _description = value;
                },
              ),
              SizedBox(height: 20),
              FormField<bool>(
                initialValue: false,
                validator: (value) {
                  if (value == true) return null;
                  return "devi accettare i termini e condizioni";
                },
                errorBuilder: (context, errorText) {
                  print(errorText);
                  return Text(errorText);
                },
                builder: (field) {
                  return CheckboxListTile(
                    value: field.value,
                    contentPadding: EdgeInsets.zero,
                    title: Text("accetto i t&c"),
                    onChanged: (value) {
                      if (value == null) return;
                      field.didChange(value);
                      _isDone = value;
                    },
                  );
                },
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  final state = _key.currentState?.validate();
                  if (state == true) {
                    // è valido!
                    final todo = Todo(
                      createdAt: DateTime.now(),
                      title: _title!,
                      description: _description!,
                      isDone: _isDone,
                    );

                    Navigator.pop(context, todo);
                    return;
                  }
                },
                child: Text("salva!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}