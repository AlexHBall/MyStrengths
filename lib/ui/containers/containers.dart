import 'package:flutter/material.dart';

class EntryContainer extends StatelessWidget {
  String text;
  EntryContainer(String this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
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

class LoadingContainer extends StatelessWidget {
  LoadingContainer();
  @override
  Widget build(BuildContext context) {
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
}

class NoFrequencies extends StatelessWidget {
  NoFrequencies();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Add a new notification below!",
      ),
    );
  }
}
