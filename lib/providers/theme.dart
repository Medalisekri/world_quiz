import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const String _boxName = 'app_box';
  static const String _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.dark;
  }

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_boxName);
    final savedTheme = box.get(_themeKey, defaultValue: 'dark');
    state = savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;
    final box = Hive.box(_boxName);
    await box.put(_themeKey, newMode == ThemeMode.dark ? 'dark' : 'light');
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);