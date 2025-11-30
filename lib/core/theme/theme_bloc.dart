
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'theme_mode';
  static const String _themeColorKey = 'theme_color';
  final SharedPreferences _prefs;

  ThemeBloc(this._prefs) : super(ThemeState.initial()) {
    // Register event handlers
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
    on<ChangeThemeColorEvent>(_onChangeThemeColor);
  }

  /// Load the saved theme preference from SharedPreferences
  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final isDark = _prefs.getBool(_themeKey) ?? true; // Default to dark theme
      final colorValue = _prefs.getInt(_themeColorKey) ?? 0xFF8875FF; // Default lavender purple
      emit(ThemeState(
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        isDarkMode: isDark,
        primaryColor: Color(colorValue),
      ));
    } catch (e) {
      // If there's an error, default to dark theme
      emit(ThemeState.initial());
    }
  }

  /// Toggle between light and dark themes
  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final newIsDark = !state.isDarkMode;
    await _saveThemePreference(newIsDark);
    emit(ThemeState(
      themeMode: newIsDark ? ThemeMode.dark : ThemeMode.light,
      isDarkMode: newIsDark,
      primaryColor: state.primaryColor,
    ));
  }

  /// Set a specific theme (light or dark)
  Future<void> _onSetTheme(
    SetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _saveThemePreference(event.isDark);
    emit(ThemeState(
      themeMode: event.isDark ? ThemeMode.dark : ThemeMode.light,
      isDarkMode: event.isDark,
      primaryColor: state.primaryColor,
    ));
  }

  /// Change the primary color of the theme
  Future<void> _onChangeThemeColor(
    ChangeThemeColorEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _saveThemeColor(event.color);
    emit(state.copyWith(primaryColor: event.color));
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveThemePreference(bool isDark) async {
    try {
      await _prefs.setBool(_themeKey, isDark);
    } catch (e) {
      // Handle error silently or log it
      debugPrint('Error saving theme preference: $e');
    }
  }

  /// Save theme color to SharedPreferences
  Future<void> _saveThemeColor(Color color) async {
    try {
      await _prefs.setInt(_themeColorKey, color.toARGB32());
    } catch (e) {
      // Handle error silently or log it
      debugPrint('Error saving theme color: $e');
    }
  }
}
