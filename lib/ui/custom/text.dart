import 'package:flutter/material.dart';

/// Builds a textbox with text theme body 2 style
class Body2Text extends StatelessWidget {
  final String displayText;
  Body2Text(this.displayText);

  @override
  Widget build(BuildContext context) {
    return Text(
      displayText,
      style: Theme.of(context).textTheme.body2,
    );
  }
}

/// Builds a textbox with text theme body 1 style
class Body1Text extends StatelessWidget {
  final String displayText;
  Body1Text(this.displayText);

  @override
  Widget build(BuildContext context) {
    return Text(
      displayText,
      style: Theme.of(context).textTheme.body1,
    );
  }
}

/// Builds a textbox with text theme body 1 style
class Display1Text extends StatelessWidget {
  final String displayText;
  Display1Text(this.displayText);

  @override
  Widget build(BuildContext context) {
    return Text(
      displayText,
      style: Theme.of(context).textTheme.display1,
    );
  }
}