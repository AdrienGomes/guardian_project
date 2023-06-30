import 'package:flutter/material.dart';
import 'package:guardian_project/common/widget/theme/guardian_theme_color.dart';

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
            stateOffColor: GuardianThemeColor.stateOffColor),
        ListeningProfileThemeExtension(
            selectedTileColor: GuardianThemeColor.listeningProfileSelectedBackgroundColor,
            unselectedTileColor: GuardianThemeColor.listeningProfileUnselectedBackgroundColor,
            selectedTextColor: GuardianThemeColor.commonCyan,
            unselectedTextColor: GuardianThemeColor.commonWhite)
      ]);
}

/// Theme extension for [RippleButton]
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

/// Theme extension for [ListeningProfile]
class ListeningProfileThemeExtension extends ThemeExtension<ListeningProfileThemeExtension> {
  Color? unselectedTileColor;
  Color? selectedTileColor;
  Color? unselectedTextColor;
  Color? selectedTextColor;

  ListeningProfileThemeExtension(
      {this.unselectedTileColor, this.selectedTextColor, this.selectedTileColor, this.unselectedTextColor});

  @override
  ThemeExtension<ListeningProfileThemeExtension> copyWith(
          {Color? selectedTextColor,
          Color? selectedTileColor,
          Color? unselectedTileColor,
          Color? unselectedTextColor}) =>
      ListeningProfileThemeExtension(
          selectedTextColor: selectedTextColor ?? this.selectedTextColor,
          selectedTileColor: selectedTileColor ?? this.selectedTileColor,
          unselectedTextColor: unselectedTextColor ?? this.unselectedTextColor,
          unselectedTileColor: unselectedTileColor ?? this.unselectedTileColor);

  @override
  ThemeExtension<ListeningProfileThemeExtension> lerp(ThemeExtension<ListeningProfileThemeExtension>? other, double t) {
    if (other is! ListeningProfileThemeExtension) {
      return this;
    }

    return ListeningProfileThemeExtension(
        selectedTextColor: Color.lerp(selectedTextColor, other.selectedTextColor, t),
        selectedTileColor: Color.lerp(selectedTileColor, other.selectedTileColor, t),
        unselectedTextColor: Color.lerp(unselectedTextColor, other.unselectedTextColor, t),
        unselectedTileColor: Color.lerp(unselectedTileColor, other.unselectedTileColor, t));
  }
}
