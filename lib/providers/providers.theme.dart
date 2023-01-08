import 'package:flutter/material.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeMode themeMode;
  final IconData icon;
  final String message;
  const ThemeState({
    required this.themeMode,
    required this.icon,
    required this.message,
  });

  static const values = [
    ThemeState(
      themeMode: ThemeMode.system,
      message: 'As System',
      icon: Icons.brightness_auto,
    ),
    ThemeState(
      themeMode: ThemeMode.light,
      message: 'Light Mode',
      icon: Icons.brightness_high,
    ),
    ThemeState(
      themeMode: ThemeMode.dark,
      message: 'Dark Mode',
      icon: Icons.brightness_2,
    ),
  ];

  static ThemeState get system => values[0];

  ThemeState get next => values[(themeMode.index + 1) % values.length];

  static ThemeState fromIndex(int index) => values[index];
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  static const persistKey = 'tm';
  final SharedPreferences? pref;
  ThemeNotifier({ThemeState? theme, this.pref})
      : super(theme ?? ThemeState.system);

  factory ThemeNotifier.fromPref(SharedPreferences? pref) {
    if (pref == null) return ThemeNotifier();
    return ThemeNotifier(theme: stateOf(pref), pref: pref);
  }

  ThemeState next() {
    pref?.setInt(persistKey, state.next.themeMode.index);
    return state = state.next;
  }

  static ThemeState stateOf(SharedPreferences pref) {
    final index = pref.getInt(persistKey) ?? ThemeState.system.themeMode.index;
    return ThemeState.fromIndex(index);
  }
}
