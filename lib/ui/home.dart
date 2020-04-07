import 'package:flutter/material.dart';
import 'package:my_strengths/ui/strength_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_strengths/ui/onbaord/onboard.dart';

class Home extends StatelessWidget {
  Home();

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new LoadingScreen("loading");
          default:
            if (!snapshot.hasError) {
              // @ToDo("Return a welcome screen");
              // return snapshot.data.getBool("welcome") != null
              return snapshot.data.getBool("welcome") != false
                  ? new MyStrenghtsList()
                  : new Onboard();
            } else {
              return new ErrorScreen(snapshot.error);
            }
        }
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final String text;
  LoadingScreen(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class ErrorScreen extends StatelessWidget {
  final error;
  ErrorScreen(this.error);

  @override
  Widget build(BuildContext context) {
    return Text("Error");
  }
}
