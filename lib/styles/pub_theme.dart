import 'package:flutter/material.dart';

class PubTheme {
  PubTheme._();
  static const Color _primaryColor = Color.fromRGBO(255, 167, 0, 1);
  static const Color _lightColor = Color.fromRGBO(255, 216, 74, 1);
  static const Color _darkColor = Color.fromRGBO(198, 120, 0, 1);

  static const Color _lightBackgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color _lightOnSecondaryColor = Colors.black;
  static const Color _lightOnCardColorShadow = Colors.deepOrange;
  static const Color _lightOnPointColor = Colors.black54;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightBackgroundColor,
    primaryColor: _primaryColor,
    primaryColorLight: _lightColor,
    primaryColorDark: _darkColor,
    accentColor: _lightBackgroundColor,
    //primarySwatch: _primaryColor,
    appBarTheme: AppBarTheme(
      color: _lightBackgroundColor,
      elevation: 10,
      textTheme: TextTheme(
        title: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: _primaryColor),
      ),
    ),
    bottomAppBarTheme:
        BottomAppBarTheme(color: Colors.white10, elevation: 10.0),

    buttonTheme: ButtonThemeData(
      padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      textTheme: ButtonTextTheme.accent,
    ),
    fontFamily: "Roboto Slab",
    textTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 30, color: _primaryColor),
      headline6: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _lightOnPointColor,
          fontStyle: FontStyle.italic),
      subtitle2: TextStyle(
        fontSize: 12.0,
        fontStyle: FontStyle.italic,
        color: _lightOnCardColorShadow,
      ),
      headline5: TextStyle(
        fontSize: 8.0,
        fontStyle: FontStyle.italic,
        color: _lightOnCardColorShadow,
      ),
      headline3: TextStyle(
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        color: _lightOnSecondaryColor,
      ),
      subtitle1: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: _lightOnSecondaryColor,
      ),
      bodyText1: TextStyle(
        fontSize: 14.0,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
