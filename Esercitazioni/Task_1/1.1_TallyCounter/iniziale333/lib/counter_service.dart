import 'package:flutter/foundation.dart';

class CounterService extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }

  void reset() {
    _counter = 0;
    notifyListeners();
  }

  void doubleCounter() {
    _counter *= 2;
    notifyListeners();
  }

  void halve() {
    _counter = _counter ~/ 2;
    notifyListeners();
  }
}