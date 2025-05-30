import 'package:flutter/material.dart';
import 'package:post_app/ui/core/themes/dark_theme.dart';
import 'package:post_app/ui/core/themes/light_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;
  bool _isDark = false;

  ThemeData get theme => _themeData;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    _themeData = _isDark ? darkTheme : lightTheme;
    notifyListeners();
  }
}
