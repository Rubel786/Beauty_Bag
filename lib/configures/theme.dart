import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.brown,
      fontFamily: 'Mulish',
      scaffoldBackgroundColor: Colors.white, // <-- Set global SafeArea/Scaffold color here
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.brown,
        primary: Colors.brown,
      ),
    );
  }
}
