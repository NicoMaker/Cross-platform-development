import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Saluti',
      home: SalutoPage(),
    );
  }
}

class SalutoPage extends StatefulWidget {
  const SalutoPage({super.key});

  @override
  _SalutoPageState createState() => _SalutoPageState();
}

class _SalutoPageState extends State<SalutoPage> {

  final FormGroup myForm = FormGroup({
    'nome': FormControl<String>(value: ''),
    'saluto': FormControl<String>(value: ''),
  });

  String? messaggio; 

  void creaSaluto() {
    final nome = myForm.control('nome').value ?? '';
    final saluto = myForm.control('saluto').value ?? 'Hello';

    if (nome.trim().isEmpty) {
      setState(() {
        messaggio = 'Inserisci prima il tuo nome!';
      });
      return;
    }

    setState(() {
      messaggio = '$saluto, $nome!';
    });
  }

  void pulisciCampi() {
    myForm.reset(value: {'nome': '', 'saluto': 'Hello'});
    setState(() {
      messaggio = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Saluti')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ReactiveForm(
          formGroup: myForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              ReactiveTextField<String>(
                formControlName: 'nome',
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              
              ReactiveTextField<String>(
                formControlName: 'saluto',
                decoration: InputDecoration(
                  labelText: 'Saluto',
                  hintText: 'Scrivi il tuo saluto',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

       
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: creaSaluto,
                      child: Text('Saluta'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: pulisciCampi,
                      child: Text('Pulisci'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

       
              if (messaggio != null)
                Text(
                  messaggio!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.teal),
                ),
            ],
          ),
        ),
      ),
    );
  }
}