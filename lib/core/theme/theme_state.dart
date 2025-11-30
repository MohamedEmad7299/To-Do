import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isDarkMode;
  final Color primaryColor;

  const ThemeState({
    required this.themeMode,
    required this.isDarkMode,
    required this.primaryColor,
  });

  /// Initial state with dark theme as default
  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: ThemeMode.dark,
      isDarkMode: true,
      primaryColor: Color(0xFF8875FF), // Default lavender purple
    );
  }

  /// Create a copy of the current state with updated values
  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isDarkMode,
    Color? primaryColor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }

  @override
  List<Object> get props => [themeMode, isDarkMode, primaryColor];
}
