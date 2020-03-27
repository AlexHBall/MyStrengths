import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_strengths/ui/custom/box_decoration.dart';
import '../../models/frequency.dart';

class Dialogs {
  deleteDialog(BuildContext context) {
    //TODO: Delete this once frequencies are dismissables
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
                      children: <Widget>[
                        new Text(
                          'Delete notifcation?',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
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
}

class EditEntryDialog extends StatelessWidget {
  final TextEditingController eCtrl;
  EditEntryDialog(this.eCtrl);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    SizedBox(
                      width: 55,
                    ),
                    Container(
                      child: Text("Edit your entry"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    // decoration: MyDecorator.getOldDecorator(),
                    child: TextField(
                        autofocus: true,
                        controller: eCtrl,
                        style: Theme.of(context).textTheme.body2,
                        onSubmitted: (String text) {
                          Navigator.pop(context, text);
                        }),
                  ),
                ),
              ],
            ),
          )
        ],
      );
}

class EnterFrequencyDialog extends StatelessWidget {
  final TextEditingController eCtrl = new TextEditingController();
  EnterFrequencyDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) =>
      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(
                    width: 55,
                  ),
                  Container(
                    child: Text("Remind me after"),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                // child: Row(
                //   children: <Widget>[
                child: TextField(
                  style: Theme.of(context).textTheme.body2,
                  autofocus: true,
                  controller: eCtrl,
                  onSubmitted: (String text) {
                    sumbitFrequency(context, text);
                  },
                  decoration: new InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    // hintText: "Days",
                    // hintStyle: Theme.of(context).textTheme.body2,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                ),
                // FlatButton(
                //     onPressed: () {
                //       sumbitFrequency(context, eCtrl.text.toString());
                //     },
                //     child: Text(
                //       'Day(s)',
                //       style: Theme.of(context).textTheme.body2,
                //     )),
                //   ],
                // ),
              ),
              Text("Days")
            ],
          ),
        )
      ]);

  sumbitFrequency(BuildContext context, String text) {
    int duration;
    try {
      duration = int.parse(text);
    } on FormatException catch (e) {
      debugPrint(e.message);
      return;
    }
    if (duration > 0) {
      Frequency frequency = new Frequency(duration);
      Navigator.pop(context, frequency);
    }
  }

  // new Expanded(
  //   child: new Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       new FlatButton(
  //           onPressed: () {
  //             int duration = int.parse(eCtrl.text.toString());
  //             if (duration > 0) {
  //               Frequency frequency = new Frequency(duration);
  //               Navigator.pop(context, frequency);
  //             }
  //           },
  //           child: new Text('Day(s)')),
  // ],
  // ),
  // )
}
