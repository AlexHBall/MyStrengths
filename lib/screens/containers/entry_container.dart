import 'package:flutter/material.dart';

class EntryContainer {
  entryContainer(String text, BuildContext context) {
    return new Container(
      alignment: Alignment(0.0, 0.0),
      padding: new EdgeInsets.all(10.0),
      child: Text(text, style: Theme.of(context).textTheme.body1),
      decoration: BoxDecoration(
        color: Colors.white24,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(100))),
    );
  }
}
