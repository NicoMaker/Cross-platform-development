import "package:flutter_riverpod/flutter_riverpod.dart";

final NotifierProvider<CounterNotifier, int> counterProvider = NotifierProvider(
  CounterNotifier.new,
);

class CounterNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state = state + 1;
  }

  void decrement() {
    state = state - 1;
  }

  void double() {
    state = state * 2;
  }

  void halve() {
    state = state ~/ 2;
  }
}
