import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    title: 'Agenzia delle Entrate',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Benvenuto nella Agenzia delle entrate'),
        ),
        body: const GreeterWidget(),
      ),
    );
  }
}

class GreeterWidget extends StatefulWidget {
  const GreeterWidget({super.key});

  @override
  State<GreeterWidget> createState() => _GreeterWidgetState();
}

class _GreeterWidgetState extends State<GreeterWidget> {
  String _message = '';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _updateGreeting() {
    setState(() {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        _message = 'Benvenuto, $firstName $lastName!';
      } else if (firstName.isNotEmpty) {
        _message = 'Benvenuto, $firstName!';
      } else if (lastName.isNotEmpty) {
        _message = 'Benvenuto, $lastName!';
      } else {
        _message = 'Per piacere, inserisci il tuo nome e cognome.';
      }
    });
  }

  void _clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    setState(() {
      _message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            labelText: 'Nome',
            hintText: 'Nome',
          ),
        ),
        TextField(
          controller: _lastNameController,
          decoration: const InputDecoration(
            labelText: 'Cognome',
            hintText: 'Cognome',
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: _updateGreeting,
              child: const Text('Procedi'),
            ),
            ElevatedButton(
              onPressed: _clearFields,
              child: const Text('Cancella'),
            ),
          ],
        ),
        Text(_message),
      ],
    );
  }
}
