import 'package:flutter/material.dart';
import 'package:my_strengths/ui/custom/custom_ui.dart';
import 'package:my_strengths/utils/utils.dart';

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
              AppLocalizations.of(context).translate("loading_entries"),
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
          AppLocalizations.of(context).translate("add_notification_reminder")),
    );
  }
}

class NoEntries extends StatelessWidget {
  NoEntries();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        AppLocalizations.of(context).translate('add_new_entry'),
      ),
    );
  }
}

class DeleteContainer extends StatelessWidget {
  DeleteContainer();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          DeleteIcon(),
          SizedBox(width: 10.0),
        ],
      ),
      color: Colors.red,
    );
  }
}

class EditContainer extends StatelessWidget {
  EditContainer();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 10.0),
          EditIcon(),
        ],
      ),
      color: Colors.green,
    );
  }
}

class StrengthInputContainer extends StatelessWidget {
  final Function(String) onSubmitted;

  final TextEditingController eCtrl = new TextEditingController();
  final InputDecoration decoration;
  StrengthInputContainer(this.onSubmitted, this.decoration);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.insert_emoticon, color: Colors.white),
          iconSize: 30,
          onPressed: null,
        ),
        SizedBox(
          width: 7.5,
        ),
        Expanded(
          child: Container(
            child: new TextField(
              // autofocus: true,
              cursorColor: Colors.white,
              style: Theme.of(context).textTheme.body2,
              controller: eCtrl,
              onSubmitted: (String text) async {
                if (text != null) {
                  onSubmitted(text);
                }
              },
              // textAlignVertical: TextAlignVertical.center,
              decoration: decoration,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}
