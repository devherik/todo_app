import 'package:flutter/material.dart';

abstract class ThemeApp {
  static ThemeData get themeData {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    );
  }
}
