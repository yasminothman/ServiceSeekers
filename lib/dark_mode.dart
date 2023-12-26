// dark_mode.dart
import 'package:flutter/material.dart';

class DarkMode {
  static bool isDarkModeEnabled = false;

  static ThemeMode get currentThemeMode =>
      isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light;

  static void toggleDarkMode(bool value) {
    isDarkModeEnabled = value;
  }
}

class DarkModeButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onPressed;

  const DarkModeButton({
    required this.isDarkMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isDarkMode ? Icons.nights_stay : Icons.wb_sunny,
        color: isDarkMode ? Colors.yellow : Colors.orange,
      ),
      onPressed: onPressed,
    );
  }
}

