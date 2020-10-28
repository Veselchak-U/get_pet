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
  // accentColor: Colors.pink[300],
  canvasColor: Colors.white,
  shadowColor: Colors.black,
  // scaffoldBackgroundColor: Colors.white,
  // bottomAppBarColor: Colors.pink[300],
  // cardColor: Colors.pink[300],
  // dividerColor: Colors.pink[300],
  // focusColor: Colors.pink[300],
  // hoverColor: Colors.pink[300],
  // highlightColor: Colors.pink[300],
  // splashColor: Colors.pink[300],
  // selectedRowColor: Colors.pink[300],
  // unselectedWidgetColor: Colors.pink[300],
  // disabledColor: Colors.pink[300],
  // buttonColor: Colors.pink[300],
  // secondaryHeaderColor: Colors.pink[300],
  textSelectionColor: Color(0xffb7b7b7),
  cursorColor: Color(0xff575757),
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
      color: Color(0xff575757), //Color(0xff949494),
    ),
  ),
  iconTheme: IconThemeData(
    color: Color(0xff575757), //Color(0xff949494),
  ),
  textTheme: TextTheme(),
);
