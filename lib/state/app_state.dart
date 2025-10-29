import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Centralized app state for simple settings without external state libs.
class AppState {
  AppState._internal();
  static final AppState I = AppState._internal();

  static const _kThemeModeKey = 'settings.theme_mode';
  static const _kNotificationsKey = 'settings.notifications_enabled';

  // Theme mode notifier to rebuild MaterialApp reactively.
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);
  bool notificationsEnabled = true;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_kThemeModeKey);
    final notif = prefs.getBool(_kNotificationsKey);
    if (themeString != null) {
      themeMode.value = _themeModeFromString(themeString);
    }
    if (notif != null) {
      notificationsEnabled = notif;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeModeKey, _themeModeToString(mode));
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotificationsKey, enabled);
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  ThemeMode _themeModeFromString(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
