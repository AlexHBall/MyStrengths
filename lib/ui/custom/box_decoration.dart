import 'package:flutter/material.dart';

class MyDecorator {
  static BoxDecoration getDecorator() {
    return BoxDecoration(
        color: Color(0xff01579b),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(6, 2),
              blurRadius: 6.0,
              spreadRadius: 3.0),
          BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.9),
              offset: Offset(-6, -2),
              blurRadius: 6.0,
              spreadRadius: 3.0)
        ]);
  }

  static BoxDecoration getOldDecorator() {
    return BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)));
  }
}
