import 'package:flutter/material.dart';

class Containers {
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

  loadingContainer(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              "Loading...",
            )
          ],
        ),
      ),
    );
  }

  noFrequencies(BuildContext context) {
    return Container(
      child: Text(
        "Add a new notification below!",
      ),
    );
  }
}
