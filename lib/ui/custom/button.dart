import 'package:flutter/material.dart';
import 'custom_ui.dart';

class OnBoardButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  OnBoardButton(this.buttonText, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Display1Text(buttonText),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.white30)));
  }
}
