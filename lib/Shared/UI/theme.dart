// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1!.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF323232)),
      headline2: base.headline1!
          .copyWith(fontSize: 18, color: const Color(0xFF323232)),
      headline3: base.headline1!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFffffff)),
      headline4: base.headline1!
          .copyWith(fontSize: 14, color: const Color(0xFF777777)),
      headline5: base.headline1!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF323232)),
      headline6: base.headline1!.copyWith(
          fontSize: 16,
          color: Colors.black
          //  Color(0xFFA4A3A3)
          ,
          fontWeight: FontWeight.normal),
      bodyText1: base.bodyText1!
          .copyWith(fontSize: 16.0, color: const Color(0xFFC9C9C9)),
      bodyText2: base.bodyText2!.copyWith(
          fontSize: 16,
          /* fontWeight: FontWeight.bold, */
          color: const Color(0xFF323232)),
      /*  subtitle1: base.subtitle1!.copyWith(
          fontSize: 14,
          color: const Color(0xFFC9C9C9)), */
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme).apply(
        // bodyColor: const Color(0xFF000000),
        // displayColor: const Color(0xFF4FC3F7),
        ),
    primaryColor: const Color(0xFF4FC3F7),
    textSelectionHandleColor: const Color(0xFF4FC3F7),
    primaryColorLight: const Color(0xFFF7EDED),
    backgroundColor: const Color(0xFFF6F6F6),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    iconTheme: const IconThemeData(
      color: Color(0xFF4FC3F7),
    ),
    textSelectionColor: const Color(0xFFCECECE),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF990000)),
  );
}
