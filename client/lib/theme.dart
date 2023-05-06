import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    chipTheme: ChipThemeData(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      backgroundColor: Colors.orange.shade300,
      elevation: 2,
      brightness: Brightness.light,
      labelStyle: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return Colors.white;
        }

        return Colors.grey.shade100;
      }),
      labelStyle: TextStyle(
          fontFamily: "Quicksand",
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600),
      floatingLabelStyle: TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Colors.orange,
          width: 2,
          strokeAlign: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    ),
    primaryColor: Colors.orange,
    primarySwatch: Colors.orange,
    brightness: Brightness.light,
    primaryColorDark: Colors.black,
    canvasColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade400,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
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
      headlineMedium: TextStyle(
        color: Color.fromRGBO(97, 97, 97, 1), //Colors.grey.shade700
        fontSize: 48,
        fontWeight: FontWeight.w600,
        fontFamily: "Montserrat",
      ),
      bodyMedium: TextStyle(
        color: Color.fromRGBO(97, 97, 97, 1), //Colors.grey.shade700
        fontSize: 20,
        fontFamily: "Montserrat",
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
