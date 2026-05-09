import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.deepPurple,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color.fromARGB(255, 127, 107, 223),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
