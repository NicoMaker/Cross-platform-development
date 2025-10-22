import 'package:flutter/material.dart';
import 'counter_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.counterService});

  final String title;
  final CounterService counterService;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Counter Value:',
            ),
            AnimatedBuilder(
              animation: widget.counterService,
              builder: (context, child) {
                return Text(
                  '${widget.counterService.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: widget.counterService.decrement,
                  tooltip: 'Decrement',
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: widget.counterService.increment,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: widget.counterService.halve,
                  child: const Text('~/2'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: widget.counterService.reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: widget.counterService.doubleCounter,
                  child: const Text('x2'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}