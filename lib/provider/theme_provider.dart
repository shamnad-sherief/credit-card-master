import 'package:credit_card_master/utils/constants.dart';
import 'package:flutter/material.dart';
import '../utils/storage_manager.dart';

class ThemeProvider with ChangeNotifier {
  // Define the light and dark themes
  final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey[800],
    brightness: Brightness.dark,
    dividerColor: Colors.black12,
    colorScheme: darkColorScheme,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
    ),
  );

  final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    dividerColor: Colors.white54,
    colorScheme: lightColorScheme,
  );

  ThemeData? _themeData;
  // Default to light theme if _themeData is null

  // Constructor that initializes the theme from storage
  ThemeProvider() {
    _initializeTheme();
  }

  // Initialize theme based on the value stored in local storage
  Future<void> _initializeTheme() async {
    // Read the saved theme mode from storage
    final themeMode = await StorageManager.readData('themeMode');
    print('Loaded themeMode from storage: $themeMode');

    // Set theme based on the stored value
    if (themeMode == 'dark') {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    notifyListeners();
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  void invertTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
      StorageManager.saveData('themeMode', 'dark');
    } else {
      _themeData = lightTheme;
      StorageManager.saveData('themeMode', 'light');
    }
    notifyListeners();
  }

  ThemeData getTheme() => _themeData ?? lightTheme;

  bool isDarkMode() {
    if (_themeData == darkTheme) {
      return true;
    } else {
      return false;
    }
  }
}
