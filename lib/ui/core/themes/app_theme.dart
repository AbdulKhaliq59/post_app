import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:post_app/ui/core/themes/dark_theme.dart';
import 'package:post_app/ui/core/themes/light_theme.dart';

class ThemeNotifier extends Notifier<ThemeData> {
  bool _isDark = false;

  @override
  ThemeData build() => lightTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    state = _isDark ? darkTheme : lightTheme;
    debugPrint("Theme changed to ${_isDark ? 'Dark' : 'Light'}");
  }

  bool get isDark => _isDark;
}

final themeProviderNotifier = NotifierProvider<ThemeNotifier, ThemeData>(
  () => ThemeNotifier(),
);
