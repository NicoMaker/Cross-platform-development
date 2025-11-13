import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/counter_page/state/counter.dart";

class CounterPage extends ConsumerStatefulWidget {
  const CounterPage({super.key});

  @override
  ConsumerState<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends ConsumerState<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("esercitazione 1.1"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("il tuo contatore è: $counter"),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(counterProvider.notifier).increment();
                },
                icon: const Icon(Icons.add),
                label: const Text("increment!"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(counterProvider.notifier).decrement();
                },
                icon: const Icon(Icons.remove),
                label: const Text("decrement!"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(counterProvider.notifier).double();
                },
                icon: const Icon(Icons.star),
                label: const Text("double!"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(counterProvider.notifier).halve();
                },
                icon: const Icon(Icons.agriculture),
                label: const Text("halve!"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
