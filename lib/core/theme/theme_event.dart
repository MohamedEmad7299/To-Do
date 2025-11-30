import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

/// Event to load the saved theme preference when the app starts
class LoadThemeEvent extends ThemeEvent {
  const LoadThemeEvent();
}

/// Event to toggle between light and dark themes
class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}

/// Event to set a specific theme (light or dark)
class SetThemeEvent extends ThemeEvent {
  final bool isDark;

  const SetThemeEvent(this.isDark);

  @override
  List<Object> get props => [isDark];
}

/// Event to change the primary color of the theme
class ChangeThemeColorEvent extends ThemeEvent {
  final Color color;

  const ChangeThemeColorEvent(this.color);

  @override
  List<Object> get props => [color];
}
