import 'dart:math';
import 'package:flutter/material.dart';

class ColorChangerPage extends StatefulWidget {
  const ColorChangerPage({super.key});

  @override
  State<ColorChangerPage> createState() => _ColorChangerPageState();
}

class _ColorChangerPageState extends State<ColorChangerPage> {
  Color _backgroundColor = Colors.white;
  Brightness _brightness = Brightness.light;

  void _changeColor(Color newColor) {
    setState(() => _backgroundColor = newColor);
  }

  void _toggleMode(bool value) {
    setState(() {
      _brightness = value ? Brightness.light : Brightness.dark;
      _backgroundColor = _brightness == Brightness.light
          ? Colors.white
          : Colors.grey[850]!;
    });
  }

  void _randomColor() {
    final random = Random();
    final colors = Colors.primaries;
    setState(() => _backgroundColor = colors[random.nextInt(colors.length)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(title: const Text('Background Color Changer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Cambia colore sfondo pls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _colorButton('Rosso', Colors.red),
                _colorButton('Verde', Colors.green),
                _colorButton('Blu', Colors.blue),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dark/Light mode'),
                Switch(
                  value: _brightness == Brightness.light,
                  onChanged: _toggleMode,
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _randomColor,
              child: const Text('Colore Random'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: () => _changeColor(color),
        child: Text(label),
      ),
    );
  }
}
