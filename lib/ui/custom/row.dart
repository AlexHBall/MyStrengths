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
class EvenlySpaceVisibilityRow extends StatelessWidget{
  final bool isSwitched;
  final List<Widget> toDisplay;
  EvenlySpaceVisibilityRow(this.isSwitched,this.toDisplay);

  @override
  Widget build(BuildContext context) {
    return Visibility(visible: isSwitched,child: EvenlySpacedRow(toDisplay),);
  }
}
