import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _doubleCounter() {
    setState(() {
      _counter *= 2;
    });
  }

  void _halveCounter() {
    setState(() {
      _counter ~/= 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Il conteggio è:'),
          Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _decrementCounter,
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _resetCounter,
                tooltip: 'Reset',
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _doubleCounter,
                tooltip: 'Double',
                child: const Icon(Icons.close),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                onPressed: _halveCounter,
                tooltip: 'Halve',
                child: Text('÷', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
