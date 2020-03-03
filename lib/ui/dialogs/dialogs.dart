import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/frequency.dart';

class Dialogs {
  information(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[Text(description)],
            )),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              )
            ],
          );
        });
  }

  deleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              child: FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 0.2,
            child: Container(
              child: Column(
                children: <Widget>[
                  new Expanded(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[new Text('Delete notifcation?')],
                    ),
                  ),
                  new Expanded(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: new Text('Yes')),
                        new FlatButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: new Text('No'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
        });
  }

  frequencyDialog(BuildContext context) {
    final TextEditingController eCtrl = new TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              child: FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 0.2,
            child: Container(
              child: Column(
                children: <Widget>[
                  new Expanded(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[new Text('Remind me after')],
                    ),
                  ),
                  new Expanded(
                    child: new TextField(
                      controller: eCtrl,
                      decoration:
                          new InputDecoration(labelText: "Enter Duration"),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        //TODO: make sure this can't be 0
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  new Expanded(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              int duration = int.parse(eCtrl.text.toString());
                              Frequency frequency =
                                  new Frequency('D', duration);
                              Navigator.pop(context, frequency);
                            },
                            child: new Text('Day(s)')),
                        new FlatButton(
                          onPressed: () {
                            int duration = int.parse(eCtrl.text.toString());
                            Frequency frequency = new Frequency('W', duration);
                            Navigator.pop(context, frequency);
                          },
                          child: new Text('Week(s)'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
        });
  }
}
