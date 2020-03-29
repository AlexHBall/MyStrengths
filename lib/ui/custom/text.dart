import 'package:flutter/material.dart';

/// Builds a textbox with text theme body 2 style
class Body2Text extends StatelessWidget {
  final String text;
  Body2Text(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.body2,
    );
  }
}

/// Builds a textbox with text theme body 1 style
class Body1Text extends StatelessWidget {
  final String text;
  Body1Text(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.body1,
    );
  }
}
