import 'package:flutter/material.dart';

abstract class StandardInputDecoration {
  static inputDecoration(
      ColorScheme theme, TextTheme textTheme, String hintText) {
    return InputDecoration(
        filled: true,
        fillColor: theme.primaryContainer,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        hintText: hintText,
        hintStyle: textTheme.bodyMedium!
            .copyWith(color: theme.onPrimaryContainer.withValues(alpha: 0.5)));
  }
}
