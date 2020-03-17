import 'package:flutter/material.dart';
import 'package:my_strengths/ui/custom/box_decoration.dart';
import 'package:my_strengths/utils/text_helper.dart';

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

class StrengthInputContainer extends StatelessWidget {
  final Function(String) onSubmitted;

  final TextEditingController eCtrl = new TextEditingController();

  StrengthInputContainer(this.onSubmitted);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: MyDecorator.getOldDecorator(),
            child: new TextField(
              style: Theme.of(context).textTheme.body2,
              controller: eCtrl,
              onSubmitted: (String text) async {
                eCtrl.clear();
                //TODO: randomly change the message promt;
                onSubmitted(text);
              },
              decoration: InputDecoration(
                  hintText: TextHelper.getPromptMessage(),
                  hintStyle: Theme.of(context).textTheme.body2),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class DisplayNameContainer extends StatelessWidget {
  final String name;
  DisplayNameContainer(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(25.0),
      child: Text("Hello $name", style: Theme.of(context).textTheme.display1),
      decoration: BoxDecoration(
        border: new Border.all(
          // color: Colors.green,
          width: 5.0,
        ),
      ),
    );
  }
}

class DisplayDateContainer extends StatelessWidget {
  final String date;
  DisplayDateContainer(this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(25.0),
      child: Text("$date", style: Theme.of(context).textTheme.display1),
      // decoration: BoxDecoration(
      //   border: new Border.all(
      //     // color: Colors.green,
      //     width: 5.0,
      //   ),
      // ),
    );
  }
}