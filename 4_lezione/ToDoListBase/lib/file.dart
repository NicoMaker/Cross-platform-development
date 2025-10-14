import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyHomePage(title: 'TO DO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<bool> _checkboxes = [
    false,
    false,
    false,
    false,
    false,
    false,
    true,
    true,
    true,
    true,
    true,
  ];

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    ),
    body: Center(
      child: ListView(
        children: [
          for (final (i, element) in _checkboxes.indexed)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Contenitore per titolo, sottotitolo e data
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Titolo ${i+1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Sottotitolo ${i+1}'),
                    Text(
                      'Data: 14/10/2025',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                // Checkbox a destra
                Checkbox(
                  value: element,
                  onChanged: (value) {
                    setState(() {
                      _checkboxes[i] = value!;
                    });
                  },
                ),
              ],
            ),
        ],
      ),
    ),
  );
}
}