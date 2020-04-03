import 'package:flutter/material.dart';
import 'package:my_strengths/ui/custom/custom_ui.dart';
import 'icons.dart';
import 'package:my_strengths/utils/utils.dart';

class BaseCard extends StatelessWidget {
  final Widget child;
  BaseCard(this.child);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: child);
  }
}

class BaseSettingCard extends StatelessWidget {
  final Widget child;
  BaseSettingCard(this.child);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: child);
  }
}

class EntryCard extends StatelessWidget {
  EntryCard(this.entryText);
  final String entryText;
  void _handleOnPressed() async {
    print("YUMMY YUMMY");
    //TODO1: Make it display the input text?
  }

  @override
  Widget build(BuildContext context) {
    Container child = Container(
        padding: EdgeInsets.only(left: 10),
        child: new Row(
          children: <Widget>[
            InputIcon(_handleOnPressed),
            new Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 10, right: 30),
              child: Body1Text(entryText),
            )),
          ],
        ));

    return BaseCard(child);
  }
}

class NameCard extends StatelessWidget {
  final String name;
  final Function(String) onNewNameEntered;
  final TextEditingController eCtrl;
  NameCard(this.onNewNameEntered, this.name, this.eCtrl);

  @override
  Widget build(BuildContext context) {
    Container child = Container(
        child: new Column(
      children: <Widget>[
        Display1Text(AppLocalizations.of(context).translate('name')),
        // StrengthInputContainer(onNewNameEntered,InputDecoration()),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
            ),
            controller: eCtrl,
            style: Theme.of(context).textTheme.body2,
            onFieldSubmitted: (String value) {
              onNewNameEntered(value);
            },
          ),
        ),

        SizedBox(
          height: 5.0,
        )
      ],
    ));
    return BaseSettingCard(child);
  }
}

class NotificationEnabledCard extends StatelessWidget {
  final bool isSwitched;
  final Function(bool) onSwitched;

  NotificationEnabledCard(this.onSwitched, this.isSwitched);

  @override
  Widget build(BuildContext context) {
    Switch notificationEnabled = Switch(
      value: isSwitched,
      onChanged: onSwitched,
      activeTrackColor: Colors.white,
      activeColor: Colors.grey,
    );

    List<Widget> enabledRow = [
      Body1Text(AppLocalizations.of(context).translate('notification_enabled')),
      notificationEnabled
    ];

    Container child = Container(
      child: Column(
        children: <Widget>[
          Display1Text(AppLocalizations.of(context).translate("notifications")),
          EvenlySpacedRow(enabledRow),
        ],
      ),
    );
    return BaseSettingCard(child);
  }
}

class FrequencyCard extends StatelessWidget {
  final String frequencyText;
  FrequencyCard(this.frequencyText);

  @override
  Widget build(BuildContext context) {
    Container childContainer = Container(
        padding: EdgeInsets.only(left: 10),
        child: new Row(
          children: <Widget>[
            NotificationIcon(),
            new Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 10, right: 30),
              child: Body1Text(frequencyText),
            )),
          ],
        ));
    return BaseSettingCard(childContainer);
  }
}
