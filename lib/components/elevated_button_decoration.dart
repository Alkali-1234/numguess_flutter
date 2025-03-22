import 'package:flutter/material.dart';

abstract class ElevatedButtonDecoration {
  static primaryElevatedButtonDecoration(
      ColorScheme theme, TextTheme textTheme) {
    return ElevatedButton.styleFrom(
        backgroundColor: theme.primary,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(15),
        ));
  }

  static secondaryElevatedButtonDecoration(
      ColorScheme theme, TextTheme textTheme) {
    return ElevatedButton.styleFrom(
        backgroundColor: theme.secondaryContainer,
        shape: RoundedRectangleBorder(
            side: BorderSide.none, borderRadius: BorderRadius.circular(15)));
  }
}
