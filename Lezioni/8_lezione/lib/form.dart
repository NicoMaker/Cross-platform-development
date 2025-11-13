import "package:flutter/material.dart";
import "package:its_aa_pn_2025_cross_platform/todo.dart";
import "package:reactive_forms/reactive_forms.dart";

class AddTodoFormDialog extends StatefulWidget {
  const AddTodoFormDialog({super.key});

  @override
  State<AddTodoFormDialog> createState() => _AddTodoFormDialogState();
}

class _AddTodoFormDialogState extends State<AddTodoFormDialog> {
  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      "title": FormControl<String>(
        value: "",
        validators: [
          const RequiredValidator(),
          const MinLengthValidator(3),
        ],
      ),
      "description": FormControl<String>(
        value: "",
        validators: [
          const RequiredValidator(),
          const MinLengthValidator(20),
        ],
      ),
      "t&c": FormControl<bool>(
        value: false,
        validators: [
          const RequiredValidator(),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ReactiveForm(
          formGroup: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("nuovo todo!", style: theme.textTheme.headlineSmall),
              const SizedBox(height: 40),
              ReactiveTextField(
                formControlName: "title",
                decoration: const InputDecoration(hintText: "titolo..."),
              ),
              ReactiveTextField(
                formControlName: "description",
                decoration: const InputDecoration(hintText: "descrizione..."),
              ),
              const SizedBox(height: 20),
              ReactiveCheckboxListTile(
                formControlName: "t&c",
                contentPadding: EdgeInsets.zero,
                title: const Text("accetto i t&c"),
              ),
              const SizedBox(height: 80),
              ElevatedButton(onPressed: _submit, child: const Text("salva!")),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_form.valid) return;

    final todo = Todo(
      createdAt: DateTime.now(),
      title: _form.control("title").value as String,
      description: _form.control("description").value as String,
      isDone: _form.control("t&c").value as bool,
    );

    Navigator.pop(context, todo);
  }
}
