import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom/dialogs.dart';
import '../models/frequency.dart';
import 'package:my_strengths/bloc/frequency_bloc.dart';
import 'package:my_strengths/ui/custom/containers.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  bool isSwitched = true;
  final TextEditingController eCtrl = new TextEditingController();
  FrequencyBloc _frequencyBloc;
  Dialogs myDialogs = new Dialogs();
  static const namePreferenceKey = 'name';
  static const enabledPreferenceKey = 'enabled';
  SharedPreferences prefs;
  String oldName;

  void showNotifications() async {
    debugPrint('isSwitched $isSwitched');
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(enabledPreferenceKey, isSwitched);
  }

  @override
  void initState() {
    _frequencyBloc = new FrequencyBloc();
    super.initState();
     _getPreferences();
  }

  _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(namePreferenceKey);
    if (name != null) {
      oldName = name;
      setState(() {});
    }

    bool switched = prefs.getBool(enabledPreferenceKey);
    if (switched != null) {
      setState(() {
        isSwitched = switched;
      });
    }
  }

  @override
  build(BuildContext context) {
    Dialogs dialog = new Dialogs();
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: <Widget>[
          _getNameRow(),
          _getSwitchRow(),
          SizedBox(
            height: 20,
          ),
          Visibility(
              visible: isSwitched,
              child: new Expanded(
                child: getFrequencyList(),
              ))
        ],
      ),
      floatingActionButton: Visibility(
        visible: isSwitched,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final Frequency result = await dialog.frequencyDialog(context);
            _frequencyBloc.addFrequency(result);
          },
          label: Text('Add new notification'),
          icon: Icon(Icons.add_alarm),
          backgroundColor: Colors.blueAccent,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Row _getNameRow() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'What is your name?',
          style: Theme.of(context).textTheme.body2,
        ),
        new Flexible(child: _getNameField()),
      ],
    );
  }

  Row _getSwitchRow() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Enable notifications',
          style: Theme.of(context).textTheme.body2,
        ),
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              showNotifications();
            });
          },
          activeTrackColor: Colors.lightBlueAccent,
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  TextField _getNameField() {
    return new TextField(
      controller: eCtrl,
      decoration: InputDecoration(
        hintText: oldName,
        hintStyle: Theme.of(context).textTheme.body2,
      ),
      textAlign: TextAlign.center,
      onSubmitted: (String text) async {
        if (prefs == null) {
          prefs = await SharedPreferences.getInstance();
        }
        await prefs.setString(namePreferenceKey, text);
      },
    );
  }

  getFrequencyList() {
    return StreamBuilder(
      stream: _frequencyBloc.frequency,
      builder: (BuildContext context, AsyncSnapshot<List<Frequency>> snapshot) {
        return getFrequencyWidget(snapshot);
      },
    );
  }

  getFrequencyWidget(AsyncSnapshot<List<Frequency>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Frequency frequency = snapshot.data[itemPosition];
                return new GestureDetector(
                    onTap: () async {
                      final delete = await myDialogs.deleteDialog(context);
                      if (delete) {
                        _frequencyBloc.deleteFrequency(frequency.id);
                      }
                    },
                    child: Text(
                      frequency.getNotificationString(),
                      style: Theme.of(context).textTheme.body2,
                    ));
              })
          : Container(child: Center(child: NoFrequencies()));
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    _frequencyBloc.getFrequencies();
    return LoadingContainer();
  }
}
