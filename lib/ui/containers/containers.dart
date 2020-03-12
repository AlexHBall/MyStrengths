import 'package:flutter/material.dart';
import 'package:my_strengths/utils/text_helper.dart';

class EntryContainer extends StatelessWidget {
  EntryContainer(this.text);
  final text;

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

class InputContainer extends StatelessWidget {
  final Function(String) onSubmitted;

  final TextEditingController eCtrl = new TextEditingController();

  InputContainer(this.onSubmitted);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: new TextField(
        style: Theme.of(context).textTheme.body2,
        controller: eCtrl,
        onSubmitted: (String text) async {
          eCtrl.clear();
          onSubmitted(text);
        },
        decoration: InputDecoration(
            hintText: TextHelper.getPromptMessage(),
            hintStyle: Theme.of(context).textTheme.body2),
        textAlign: TextAlign.center,
      ),
    );
  }
}
