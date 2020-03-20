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
              // autofocus: true,
              style: Theme.of(context).textTheme.body2,
              controller: eCtrl,
              onSubmitted: (String text) async {
                if (text != null) {
                  onSubmitted(text);
                }
                eCtrl.clear();
                //TODO: randomly change the message promt;
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
