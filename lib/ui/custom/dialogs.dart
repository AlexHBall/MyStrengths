import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_strengths/ui/custom/custom_ui.dart';
import 'package:my_strengths/utils/utils.dart';
import '../../models/frequency.dart';

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
                      child: Text(
                          AppLocalizations.of(context).translate('edit_entry')),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: TextField(
                        autofocus: true,
                        controller: eCtrl,
                        style: Theme.of(context).textTheme.display1,
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
  final TextEditingController eCtrl;
  EnterFrequencyDialog(this.eCtrl);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) {
    IconButton cancelButton = IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {
          Navigator.pop(context);
        });

    String create =
        AppLocalizations.of(context).translate("create_notification");

    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          children: <Widget>[
            LeftAlignedTextRow(cancelButton, create),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
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
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Text(AppLocalizations.of(context).translate("days_under"))
          ],
        ),
      )
    ]);
  }

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
}
