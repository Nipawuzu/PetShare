import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    primaryColor: Colors.orange,
    primarySwatch: Colors.orange,
    brightness: Brightness.light,
    primaryColorDark: Colors.black,
    canvasColor: Colors.white,
    buttonTheme: const ButtonThemeData(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      disabledColor: Colors.orange,
      hoverColor: Colors.orange,
      focusColor: Colors.orange,
      buttonColor: Colors.orange,
      colorScheme: ColorScheme.light(
        background: Colors.orange,
      ),
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme().apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
      fontFamily: "Quicksand",
    ),
    primaryTextTheme: const TextTheme(
      labelLarge: TextStyle(
        fontFamily: "Quicksand",
      ),
      bodyMedium: TextStyle(
        fontFamily: "Quicksand",
      ),
    ),
    appBarTheme: const AppBarTheme(
      toolbarHeight: 50,
      iconTheme: IconThemeData(color: Colors.black),
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontFamily: "Quicksand",
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    primaryColor: Colors.black,
    primaryColorLight: Colors.black,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black,
    indicatorColor: Colors.white,
    canvasColor: Colors.black,
    appBarTheme: const AppBarTheme(),
  );
}
