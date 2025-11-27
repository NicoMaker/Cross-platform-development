import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class AppThemeState {
  final bool isDarkMode;
  final Color selectedColor;

  AppThemeState({required this.isDarkMode, required this.selectedColor});
  AppThemeState copyWith({bool? isDarkMode, Color? selectedColor}) {
    return AppThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}


class ThemeNotifier extends Notifier<AppThemeState> {

  @override
  AppThemeState build() {
    return AppThemeState(isDarkMode: false, selectedColor: Colors.blue);
  }
  void toggleDarkMode(bool value) {
    state = state.copyWith(isDarkMode: value);
  }
  void changeColor(Color newColor) {
    state = state.copyWith(selectedColor: newColor);
  }
  void setRandomColor() {
    final Random random = Random();
    final Color randomColor = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
    state = state.copyWith(selectedColor: randomColor);
  }
}
final themeProvider = NotifierProvider<ThemeNotifier, AppThemeState>(() {
  return ThemeNotifier();
});