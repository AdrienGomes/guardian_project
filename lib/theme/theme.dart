import 'package:flutter/material.dart';
import 'package:guardian_project/theme/guardian_theme_color.dart';

/// Guardian app theme
class GuardianTheme {
  /// App [ThemeData]
  late final ThemeData theme;

  /// Base ctor
  GuardianTheme({bool darkMode = false}) {
    theme = _getThemeDataWithExtensions(
        ThemeData(
            colorScheme: _toColorScheme(darkMode),
            bottomNavigationBarTheme: _toNavigationBarTheme(),
            scaffoldBackgroundColor:
                darkMode ? GuardianThemeColor.darkBackgroundColor : GuardianThemeColor.lightBackgroundColor),
        darkMode);
  }

  /// app color scheme
  ColorScheme _toColorScheme(bool darkMode) => darkMode
      ? const ColorScheme.dark(primary: Colors.blue, background: GuardianThemeColor.darkBackgroundColor)
      : const ColorScheme.light(primary: Colors.lightBlue, background: GuardianThemeColor.lightBackgroundColor);

  /// navigation bar theme
  BottomNavigationBarThemeData _toNavigationBarTheme() => const BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: GuardianThemeColor.navigationBarBackgroundColor,
        selectedIconTheme: IconThemeData(
            size: 30,
            shadows: [Shadow(color: Colors.black, blurRadius: 20)],
            color: GuardianThemeColor.lightBackgroundColor),
        unselectedIconTheme: IconThemeData(size: 20, color: Colors.black),
      );

  /// add theme extensions to theme
  ThemeData _getThemeDataWithExtensions(ThemeData themeData, bool isDarkTheme) =>
      themeData.copyWith(extensions: <ThemeExtension>[
        StateButtonThemeExtension(
            colorGradient: GuardianThemeColor.buttonDefaultGradient(isDarkTheme),
            stateOnColor: GuardianThemeColor.stateOnColor,
            stateOffColor: GuardianThemeColor.stateOffColor)
      ]);
}

/// Theme extension for [BouncingStateButton]
class StateButtonThemeExtension extends ThemeExtension<StateButtonThemeExtension> {
  Gradient? colorGradient;
  Color? stateOnColor;
  Color? stateOffColor;

  StateButtonThemeExtension({this.colorGradient, this.stateOnColor, this.stateOffColor});

  @override
  ThemeExtension<StateButtonThemeExtension> copyWith(
          {Gradient? colorGradient, Color? stateOnColor, Color? stateOffColor}) =>
      StateButtonThemeExtension(
          colorGradient: colorGradient ?? this.colorGradient,
          stateOnColor: stateOnColor ?? this.stateOnColor,
          stateOffColor: stateOffColor ?? this.stateOffColor);

  @override
  ThemeExtension<StateButtonThemeExtension> lerp(ThemeExtension<StateButtonThemeExtension>? other, double t) {
    if (other is! StateButtonThemeExtension) {
      return this;
    }

    return StateButtonThemeExtension(
        colorGradient: Gradient.lerp(colorGradient, other.colorGradient, t),
        stateOnColor: Color.lerp(stateOnColor, other.stateOnColor, t),
        stateOffColor: Color.lerp(stateOffColor, other.stateOffColor, t));
  }
}
