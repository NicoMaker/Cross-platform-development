import "package:flutter/material.dart";
import "package:reactive_forms/reactive_forms.dart";

class GreeterPage extends StatefulWidget {
  const GreeterPage({super.key});

  @override
  State<GreeterPage> createState() => _GreeterPageState();
}

class _GreeterPageState extends State<GreeterPage> {
  late final FormGroup form;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      "greet": FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      "name": FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(2),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("esercitazione 1.2"),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 4,
            children: [
              ReactiveTextField<String>(
                formControlName: "greet",
              ),
              ReactiveTextField<String>(
                formControlName: "name",
              ),
              const SizedBox(height: 60),
              ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  if (formGroup.valid) {
                    final greet = formGroup.control("greet").value as String;
                    final name = formGroup.control("name").value as String;

                    return Text("$greet $name");
                  } else {
                    return const Text("please input something");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
