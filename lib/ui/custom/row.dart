import 'package:flutter/material.dart';

class EvenlySpacedRow extends StatelessWidget {
  final List<Widget> toDisplay;
  EvenlySpacedRow(this.toDisplay);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: toDisplay,
    );
  }
}

class EvenlySpaceVisibilityRow extends StatelessWidget {
  final bool isSwitched;
  final List<Widget> toDisplay;
  EvenlySpaceVisibilityRow(this.isSwitched, this.toDisplay);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isSwitched,
      child: EvenlySpacedRow(toDisplay),
    );
  }
}

class LeftAlignedTextRow extends StatelessWidget {
  final Widget leftWidget;
  final String centeredText;
  LeftAlignedTextRow(this.leftWidget, this.centeredText);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        leftWidget,
        Expanded(
          // 1st use Expanded
          child: Center(
              child: Text(
            centeredText,
            textAlign: TextAlign.center,
          ) // 2nd wrap your widget in Center
              ),
        ),
      ],
    );
  }
}
