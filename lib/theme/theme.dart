import 'package:flutter/material.dart';

/// Guardian app colors
abstract class GuardianThemeColor {
  // ----------------- static colors ----------------------

  // background colors
  static const Color darkBackgroundColor = Color.fromARGB(255, 76, 166, 255);
  static const Color lightBackgroundColor = Color.fromARGB(255, 164, 223, 255);

  // error widget colors
  static const Color errorBackgroundColor = Colors.black45;

  // toast colors
  static const Color errorToastColor = Color.fromARGB(181, 255, 94, 82);
  static const Color warningToastColor = Color.fromARGB(255, 255, 205, 131);
  static const Color infoToastColor = Color.fromARGB(255, 113, 191, 255);

  // dark dependent colors
  static Gradient buttonDefaultGradient(bool isDarkTheme) => isDarkTheme
      ? RadialGradient(colors: [
          Colors.blue.shade900,
          Colors.blue.shade800,
          Colors.blue.shade700,
        ])
      : RadialGradient(colors: [
          Colors.lightBlue.shade600,
          Colors.lightBlue.shade500,
          Colors.lightBlue.shade400,
        ]);

  static Gradient buttonSatetOnGradient = RadialGradient(colors: [
    Colors.green.shade900,
    Colors.green.shade600,
    Colors.green.shade300,
  ]);

  static Gradient buttonSatetOffGradient = RadialGradient(colors: [
    Colors.red.shade900,
    Colors.red.shade600,
    Colors.red.shade300,
  ]);

  // ----------------- other static constants ----------------------
  static const Duration animatedContainerAnimationDuration = Duration(milliseconds: 300);
}

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
            backgroundColor:
                darkMode ? GuardianThemeColor.darkBackgroundColor : GuardianThemeColor.lightBackgroundColor,
            scaffoldBackgroundColor:
                darkMode ? GuardianThemeColor.darkBackgroundColor : GuardianThemeColor.lightBackgroundColor),
        darkMode);
  }

  /// app color scheme
  ColorScheme _toColorScheme(bool darkMode) => darkMode
      ? const ColorScheme.dark(primary: Colors.blue, background: GuardianThemeColor.darkBackgroundColor)
      : const ColorScheme.light(primary: Colors.lightBlue, background: GuardianThemeColor.lightBackgroundColor);

  /// navigation bar theme
  BottomNavigationBarThemeData _toNavigationBarTheme() => BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: Colors.blue.shade900,
        selectedIconTheme: const IconThemeData(size: 30, shadows: [Shadow(color: Colors.black, blurRadius: 20)]),
        unselectedIconTheme: const IconThemeData(
          size: 20,
        ),
      );

  /// add theme extensions to theme
  ThemeData _getThemeDataWithExtensions(ThemeData themeData, bool isDarkTheme) =>
      themeData.copyWith(extensions: <ThemeExtension>[
        ErrorManagerThemeExtension(backgroundColor: GuardianThemeColor.errorBackgroundColor),
        BouncingButtonThemeExtension(colorGradient: GuardianThemeColor.buttonDefaultGradient(isDarkTheme))
      ]);
}

/// Theme extension for [ErrorManager]
class ErrorManagerThemeExtension extends ThemeExtension<ErrorManagerThemeExtension> {
  Color? backgroundColor;

  // space management
  final double width = 500;
  final double height = 400;

  ErrorManagerThemeExtension({this.backgroundColor});

  @override
  ThemeExtension<ErrorManagerThemeExtension> copyWith({Color? backgroundColor}) =>
      ErrorManagerThemeExtension(backgroundColor: backgroundColor ?? this.backgroundColor);

  @override
  ThemeExtension<ErrorManagerThemeExtension> lerp(ThemeExtension<ErrorManagerThemeExtension>? other, double t) {
    if (other is! ErrorManagerThemeExtension) {
      return this;
    }

    return ErrorManagerThemeExtension(backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t));
  }
}

/// Theme extension for [BouncingStateButton]
class BouncingButtonThemeExtension extends ThemeExtension<BouncingButtonThemeExtension> {
  Gradient? colorGradient;

  BouncingButtonThemeExtension({this.colorGradient});

  @override
  ThemeExtension<BouncingButtonThemeExtension> copyWith({Gradient? colorGradient}) =>
      BouncingButtonThemeExtension(colorGradient: colorGradient ?? this.colorGradient);

  @override
  ThemeExtension<BouncingButtonThemeExtension> lerp(ThemeExtension<BouncingButtonThemeExtension>? other, double t) {
    if (other is! BouncingButtonThemeExtension) {
      return this;
    }

    return BouncingButtonThemeExtension(
      colorGradient: Gradient.lerp(colorGradient, other.colorGradient, t),
    );
  }
}
