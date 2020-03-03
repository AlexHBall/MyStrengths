import 'package:flutter/material.dart';

//The purpose here is COLOURS, FONTS, TEXT STYLES
ThemeData basicTheme() {
  String fontFamily = 'Playfair';

  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
        headline: base.headline.copyWith(
          fontFamily: fontFamily,
          fontSize: 22.0,
          color: Colors.white,
        ),
        title: base.title.copyWith(
            fontFamily: fontFamily,
            fontSize: 30.0,
            color: Colors.white70,
            fontStyle: FontStyle.italic),
        display1: base.headline.copyWith(
          fontFamily: fontFamily,
          fontSize: 24.0,
          color: Colors.white30,
        ),
        display2: base.headline.copyWith(
          fontFamily: fontFamily,
          fontSize: 22.0,
          color: Colors.white,
        ),
        caption: base.caption.copyWith(
          color: Colors.white,
        ),
        body1: base.body1.copyWith(
            color: Colors.white,
            fontFamily: fontFamily,
            fontSize: 20,
            fontStyle: FontStyle.italic),
        body2:
            base.body2.copyWith(color: Colors.white, fontFamily: fontFamily));
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
      textTheme: _basicTextTheme(base.textTheme),
      //textTheme: Typography().white,
      primaryColor: Color(0xff01579b),
      //primaryColor: Color(0xff4829b2),
      indicatorColor: Color(0xFF807A6B),
      scaffoldBackgroundColor: Color(0xFF002f6c),
      accentColor: Color(0xFF4f83cc),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 20.0,
      ),
      buttonColor: Colors.amber,
      backgroundColor: Color(0xFFffc107),
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Color(0xffce107c),
        unselectedLabelColor: Colors.grey,
      ));
}
