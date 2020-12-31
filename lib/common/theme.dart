import 'package:flutter/material.dart';

final theme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: Colors.grey,
  brightness: Brightness.light,
  ////
  //// All available colors in ThemeData():
  ////
  primaryColor: Color(0xff575757),
  primaryColorLight: Color(0xfff5f5f5),
  primaryColorDark: Color(0xff2e2e2e),
  accentColor: Color(0xFF63C8FA),
  canvasColor: Colors.white,
  shadowColor: Colors.black,
  // scaffoldBackgroundColor: Colors.white,
  // bottomAppBarColor: Colors.pink[300],
  // cardColor: Colors.pink[300],
  // dividerColor: Colors.pink[300],
  // focusColor: Color(0xFF63C8FA), // accentColor
  // hoverColor: Colors.pink[300],
  // highlightColor: Color(0xFFEE8363),
  // splashColor: Colors.pink[300],
  selectedRowColor: Color(0xFFEE8363),
  // unselectedWidgetColor: Colors.pink[300],
  // disabledColor: Colors.pink[300],
  // buttonColor: Colors.pink[300],
  // secondaryHeaderColor: Colors.pink[300],
  textSelectionColor: Color(0xffb7b7b7),
  cursorColor: Color(0xff575757), // primaryColor
  textSelectionHandleColor: Color(0xffb7b7b7),
  backgroundColor: Colors.white,
  // dialogBackgroundColor: Colors.pink[300],
  // indicatorColor: Colors.pink[300],
  // hintColor: Colors.pink[300],
  // errorColor: Colors.pink[300],
  // toggleableActiveColor: Colors.pink[300],
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(
      color: Color(0xff575757), // primaryColor
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Color(0xff575757), // primaryColor
        fontSize: 18.0,
      ),
    ),
  ),
  iconTheme: IconThemeData(
    color: Color(0xff575757), // primaryColor
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFF63C8FA), // theme.accentColor,
        width: 2.0,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Color(0xFF63C8FA), // theme.accentColor,
      onPrimary: Colors.white,
      // Color onSurface,
      // Color shadowColor,
      elevation: 6.0,
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
      // EdgeInsetsGeometry padding,
      minimumSize: Size(0, 40),
      // BorderSide side,
      shape: StadiumBorder(),
      // MouseCursor enabledMouseCursor,
      // MouseCursor disabledMouseCursor,
      // VisualDensity visualDensity,
      // MaterialTapTargetSize tapTargetSize,
      // Duration animationDuration,
      // bool enableFeedback,
    ),
  ),
  textTheme: TextTheme(
    headline6: TextStyle(
      color: Color(0xff575757), // primaryColor
    ),
  ),
);
