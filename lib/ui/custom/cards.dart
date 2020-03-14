import 'package:flutter/material.dart';
import 'icons.dart';
import 'package:my_strengths/utils/text_helper.dart';

class EntryCard extends StatelessWidget {
  EntryCard(this.text);
  final text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Container(
          padding: EdgeInsets.only(left: 10),
          child: new Row(
            children: <Widget>[
              InputIcon(), 
              new Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 10, right: 30),
                child: new Text(text, style: Theme.of(context).textTheme.body1),
              )),
            ],
          )),
    );
  }
}
