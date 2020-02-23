import 'package:flutter/material.dart';
import 'settings.dart';

class MyAppBar {
  appBar(BuildContext context) {
    return new AppBar(
      title: new Text("My Strengths"),
      textTheme: Theme.of(context).textTheme,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Settings();
            }));
          },
        )
      ],
    );
  }
}
