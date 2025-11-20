import "dart:ui";

import "package:flutter_riverpod/flutter_riverpod.dart";

final NotifierProvider<BrightnessChangerNotifier, Brightness> brightnessProvider =
    NotifierProvider.autoDispose<BrightnessChangerNotifier, Brightness>(
      BrightnessChangerNotifier.new,
    );

class BrightnessChangerNotifier extends Notifier<Brightness> {
  @override
  Brightness build() {
    return Brightness.light;
  }

  void toggle({required bool value}) {
    state = value ? Brightness.light : Brightness.dark;
  }
}
