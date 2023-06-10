import 'package:flutter/material.dart';

/// Guardian app colors
abstract class GuardianThemeColor {
  // ----------------- static colors ----------------------

  // background colors
  static const Color darkBackgroundColor = Color.fromARGB(255, 55, 51, 145);
  static const Color lightBackgroundColor = Color.fromARGB(255, 164, 223, 255);
  static const Color navigationBarBackgroundColor = Color.fromARGB(255, 59, 125, 161);

  // toast colors
  static const Color errorToastColor = Color.fromARGB(181, 255, 94, 82);
  static const Color warningToastColor = Color.fromARGB(255, 255, 205, 131);
  static const Color infoToastColor = Color.fromARGB(255, 113, 191, 255);

  // state button colors
  static const Color stateOnColor = Color.fromARGB(255, 56, 219, 67);
  static const Color stateOffColor = Color.fromARGB(255, 253, 57, 57);

  static const Gradient buttonSatetOnGradient = RadialGradient(colors: [
    Color.fromARGB(255, 27, 94, 32),
    Color.fromARGB(255, 67, 160, 71),
    Color.fromARGB(255, 129, 199, 132),
  ]);

  static const Gradient buttonSatetOffGradient = RadialGradient(colors: [
    Color.fromARGB(255, 183, 28, 28),
    Color.fromARGB(255, 229, 57, 53),
    Color.fromARGB(255, 229, 115, 115),
  ]);

  // ----------------- dynamic colors ----------------------

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
}
