import 'package:flutter/material.dart';
import 'package:my_strengths/ui/custom/cards.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom/dialogs.dart';
import '../models/frequency.dart';
import 'package:my_strengths/bloc/frequency_bloc.dart';
import 'package:my_strengths/ui/custom/containers.dart';

class Settings extends StatefulWidget {
  final bool isSwitched;
  final String name;
  Settings(this.isSwitched, this.name);
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  bool isSwitched;
  String name;
  FrequencyBloc _frequencyBloc;
  Dialogs myDialogs = new Dialogs();
  static const namePreferenceKey = 'name';
  static const enabledPreferenceKey = 'enabled';
  SharedPreferences prefs;
  String oldName;
  TextEditingController eCtrl;

  InputDecoration decoration;

  @override
  void initState() {
    _frequencyBloc = new FrequencyBloc();
    isSwitched = widget.isSwitched;
    oldName = widget.name;
    eCtrl = new TextEditingController(text: oldName);
    super.initState();
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
          NameCard(_handleNameChange, oldName, eCtrl),
          SizedBox(height: 5.0),
          NotificationEnabledCard(_handleSwitchChange, isSwitched),
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
            if (result != null) {
              _frequencyBloc.addFrequency(result);
            }
          },
          label: Text('Add new notification'),
          icon: Icon(Icons.add_alarm),
          backgroundColor: Colors.grey,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _handleNameChange(String newName) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    prefs.setString(namePreferenceKey, newName);
    eCtrl = new TextEditingController(text: newName);
  }

  void _handleSwitchChange(bool newValue) {
    setState(() {
      isSwitched = newValue;
    });
    _showNotifications(newValue);
  }

  void _showNotifications(bool updatedSwitch) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    prefs.setBool(enabledPreferenceKey, updatedSwitch);
    //Works as intended
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
                    onLongPress: () async {
                      final delete = await myDialogs.deleteDialog(context);
                      if (delete) {
                        _frequencyBloc.deleteFrequency(frequency.id);
                      }
                    },
                    child: FrequencyCard(frequency.getNotificationString()));
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
