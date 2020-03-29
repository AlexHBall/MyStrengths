import 'package:flutter/material.dart';

class LeftTextRow extends StatelessWidget {
  final List<Widget> toDisplay;
  LeftTextRow(this.toDisplay);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: toDisplay,
    );
  }
}
class LeftTextVisiblityRow extends StatelessWidget{
  final bool isSwitched;
  final List<Widget> toDisplay;
  LeftTextVisiblityRow(this.isSwitched,this.toDisplay);

  @override
  Widget build(BuildContext context) {
    return Visibility(visible: isSwitched,child: LeftTextRow(toDisplay),);
  }
}
