import 'package:flutter/material.dart';
import 'package:my_strengths/ui/custom/icons.dart';
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

class InputContainer extends StatelessWidget {
  final Function(String) onSubmitted;

  final TextEditingController eCtrl = new TextEditingController();

  InputContainer(this.onSubmitted);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // InputIcon(), //TODO: Would this look better bezeled into the input?
        Expanded(
          child: Container(
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
