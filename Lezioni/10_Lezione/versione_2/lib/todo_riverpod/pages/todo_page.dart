import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:its_aa_pn_2025_cross_platform/todo_riverpod/models/todo.dart";
import "package:its_aa_pn_2025_cross_platform/todo_riverpod/state/todo_list.dart";
import "package:reactive_forms/reactive_forms.dart";

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  @override
  Widget build(BuildContext context) {
    final list = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("MY TODO LIST"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          for (var i = 0; i < list.length; i++)
            ListTile(
              leading: Checkbox(
                value: list[i].completed,
                onChanged: (value) {
                  onChecked(i, value: value);
                },
              ),
              trailing: IconButton(
                onPressed: () {
                  editTodo(i, list[i]);
                },
                icon: const Icon(Icons.edit),
              ),
              title: Text(list[i].title),
              subtitle: Text(list[i].description),
            ),
        ],
      ),
    );
  }

  void onChecked(int i, {bool? value}) {
    ref.read(todoListProvider.notifier).changeTodo(i, value: value);
  }

  Future<void> addTodo() async {
    final form = await showDialog<Map<String, Object?>>(
      context: context,
      builder: (context) {
        return const EditTodoFormDialog();
      },
    );

    if (form == null) return;

    ref.read(todoListProvider.notifier).addTodo(form);
  }

  Future<void> editTodo(int i, Todo todo) async {
    final form = await showDialog<Map<String, Object?>>(
      context: context,
      builder: (context) {
        return EditTodoFormDialog(initial: todo);
      },
    );

    if (form == null) return;

    ref.read(todoListProvider.notifier).updateTodo(i, form);
  }
}

class EditTodoFormDialog extends StatefulWidget {
  const EditTodoFormDialog({
    this.initial,
    super.key,
  });
  final Todo? initial;

  @override
  State<EditTodoFormDialog> createState() => _EditTodoFormDialogState();
}

class _EditTodoFormDialogState extends State<EditTodoFormDialog> {
  late final FormGroup form;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      "title": FormControl<String>(
        value: widget.initial?.title,
        validators: [
          Validators.required,
          Validators.minLength(3),
        ],
      ),
      "description": FormControl<String>(
        value: widget.initial?.description,
        validators: [
          Validators.required,
        ],
      ),
    });
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReactiveTextField<String>(
                formControlName: "title",
              ),
              ReactiveTextField<String>(
                formControlName: "description",
              ),
              const SizedBox(height: 20),
              ReactiveFormConsumer(
                builder: (context, formGroup, _) {
                  return ElevatedButton.icon(
                    onPressed: formGroup.valid ? onSubmitted : null,
                    icon: const Icon(Icons.save),
                    label: const Text("Salva!"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSubmitted() {
    if (form.invalid) return;
    context.pop(form.value);
  }
}
