import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_strengths/ui/custom/custom_ui.dart';

class Onboard extends StatelessWidget {
  Onboard();

  @override
  Widget build(BuildContext context) {
    Column scaffoldChild = Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Text("heelo")
      ],
    );

    var gradient = AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFF3594DD),
                Color(0xFF4563DB),
                Color(0xFF5036D5),
                Color(0xFF5B16D0),
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: OnboardAppBar(),
            body: scaffoldChild,
          ),
        ));

    // TODO: implement build
    return gradient;
  }
}
