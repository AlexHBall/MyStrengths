import 'package:flutter/material.dart';
import 'package:my_strengths/ui/custom/custom_ui.dart';
import 'package:my_strengths/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/frequency.dart';
import 'package:my_strengths/bloc/frequency_bloc.dart';

class Settings extends StatefulWidget {
  final bool isSwitched;
  final String name;
  Settings(
    this.isSwitched,
    this.name,
  );
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  bool isSwitched;
  String name;
  FrequencyBloc _frequencyBloc;
  static const namePreferenceKey = 'name';
  static const enabledPreferenceKey = 'enabled';
  SharedPreferences prefs;
  String oldName;
  TextEditingController eCtrl;
  GlobalKey<ScaffoldState> scaffoldState;

  InputDecoration decoration;

  @override
  void initState() {
    _frequencyBloc = new FrequencyBloc();
    isSwitched = widget.isSwitched;
    oldName = widget.name;
    eCtrl = new TextEditingController(text: oldName);
    scaffoldState = GlobalKey();
    super.initState();
  }

  void _showSnackBar(String displayMessage) {
    SnackBar snackBar = SnackBar(
      content: Text(displayMessage),
    );
    scaffoldState.currentState.showSnackBar(snackBar);
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
  }

  Future<bool> _isDurationUnique(int duration) async {
    List<Frequency> list = await _frequencyBloc.getFrequenciesNow();
    var durationList = list.where((element) => element.duration == duration);
    if (durationList.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  build(BuildContext context) {
    String displayMessage =
        AppLocalizations.of(context).translate("notification_exists");

    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('settings')),
      ),
      body: Column(
        children: <Widget>[
          NameCard(_handleNameChange, oldName, eCtrl),
          SizedBox(
            height: 5.0,
          ),
          NotificationEnabledCard(_handleSwitchChange, isSwitched),
          SizedBox(
            height: 5.0,
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
            Frequency result = await showDialog(
                context: context,
                builder: (context) =>
                    EnterFrequencyDialog(new TextEditingController()));

            if (result != null) {
              bool addedBefore = await _isDurationUnique(result.duration);
              if (addedBefore) {
                _showSnackBar(displayMessage);
              } else {
                _frequencyBloc.addFrequency(result);
              }
            }
          },
          label:
              Text(AppLocalizations.of(context).translate('add_notification')),
          icon: Icon(Icons.add_alarm),
          backgroundColor: Colors.blue,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                return Dismissible(
                  onDismissed: (DismissDirection direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await _frequencyBloc.deleteFrequency(frequency.id);
                    } else if (direction == DismissDirection.startToEnd) {
                      TextEditingController eCtrl = new TextEditingController(
                          text: frequency.duration.toString());
                      Frequency newFrequency = await showDialog(
                          context: context,
                          builder: (context) => EnterFrequencyDialog(eCtrl));
                      if (newFrequency != null) {
                        bool addedBefore =
                            await _isDurationUnique(newFrequency.duration);
                        if (addedBefore) {
                          _showSnackBar(AppLocalizations.of(context)
                              .translate("notification_exists"));
                        } else {
                          frequency.duration = newFrequency.duration;
                          _frequencyBloc.updateFrequency(frequency);
                        }
                      }
                    }
                    _frequencyBloc.getFrequencies();
                  },
                  background: EditContainer(),
                  secondaryBackground: DeleteContainer(),
                  child: FrequencyCard(frequency.getNotificationString()),
                  key: UniqueKey(), // _myEntryBloc.getEntries(_formattedDate
                );
              },
            )
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
