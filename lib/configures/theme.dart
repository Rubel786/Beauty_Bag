import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData lightTheme(BuildContext context){
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
      fontFamily: "Muli",
    );
  }
}