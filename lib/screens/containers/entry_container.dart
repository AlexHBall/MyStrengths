import 'package:flutter/material.dart';

class EntryContainer {
  entryContainer(BuildContext context, String text) {
    return new Container(
        padding: EdgeInsets.only(left: 10),
        child: new Row(
          children: <Widget>[
            new IconButton(
              icon: Icon(Icons.insert_emoticon),
              iconSize: 35,
              color: Colors.white,
              onPressed: () {},
            ),
            new Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 10, right: 30),
              child: new Text(text, style: Theme.of(context).textTheme.body1),
            )),
          ],
        ));
  }
}
