import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final NotifierProvider<ColorChangerNotifier, Color> colorChangerProvider =
    NotifierProvider.autoDispose<ColorChangerNotifier, Color>(ColorChangerNotifier.new);

class ColorChangerNotifier extends Notifier<Color> {
  @override
  Color build() {
    return Colors.green;
  }

  void red() {
    state = Colors.red;
  }

  void green() {
    state = Colors.green;
  }

  void blue() {
    state = Colors.blue;
  }

  void randomize() {
    final random = math.Random();
    final maxColorsIndex = Colors.primaries.length;
    final randonIndex = random.nextInt(maxColorsIndex);
    final color = Colors.primaries[randonIndex];
    state = color;
  }
}
