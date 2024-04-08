import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xff505050),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.black,
    ),
    filled: true,
    fillColor: Colors.white,
  ),
  primaryColor: Colors.white,
  colorScheme: ColorScheme.dark(
    primaryContainer: Colors.black,
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.black, width: 1),
      borderRadius: BorderRadius.circular(15),
    ),
    color: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    titleTextStyle: TextStyle(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFB5BAC1),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Color(0xFF303030),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 2, color: Colors.white),
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  colorScheme: ColorScheme.light(
    primaryContainer: Colors.grey[500],
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.black, width: 1),
      borderRadius: BorderRadius.circular(15),
    ),
    color: Colors.yellow[200],
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF1e2b67),
    titleTextStyle: TextStyle(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF8ECAE6),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Color(0xFFabff70),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  tabBarTheme: TabBarTheme(
      indicator: UnderlineTabIndicator(
    borderSide: BorderSide(width: 2, color: Color(0xFF8ECAE6)),
  )),
);
