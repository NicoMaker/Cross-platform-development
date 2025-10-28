import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PersonalGreeter extends StatefulWidget {
  const PersonalGreeter({super.key});

  @override
  State<PersonalGreeter> createState() => _PersonalGreeterState();
}

class _PersonalGreeterState extends State<PersonalGreeter> {
  final form = FormGroup({
    'nome': FormControl<String>(value: ''),
    'saluto': FormControl<String>(value: ''),
  });

  String? messaggio;

  void saluta() {
    final nome = form.control('nome').value?.trim() ?? '';
    String saluto = form.control('saluto').value?.trim() ?? '';

    if (nome.isEmpty) {
      setState(() {
        messaggio = 'Inserisci prima un nome';
      });
      return;
    }

    if (saluto.isEmpty) {
      saluto = 'Hello';
    }

    setState(() {
      messaggio = '$saluto, $nome!';
    });
  }

  void pulisci() {
    form.reset();
    setState(() {
      messaggio = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Greeter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReactiveTextField<String>(
                formControlName: 'nome',
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ReactiveTextField<String>(
                formControlName: 'saluto',
                decoration: const InputDecoration(
                  labelText: 'Saluto personalizzato',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: saluta,
                      child: const Text('Saluta'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: pulisci,
                      child: const Text('Scansèa'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (messaggio != null)
                Text(
                  messaggio!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.teal),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
