import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_strengths/models/frequency.dart';
import 'package:my_strengths/models/entry.dart';
import 'package:my_strengths/ui/app_bar.dart';
import 'package:my_strengths/ui/containers/containers.dart';
import 'package:my_strengths/utils/text_helper.dart';
import 'package:my_strengths/utils/notification_helper.dart';
import 'package:my_strengths/bloc/my_strengths_bloc.dart';
import 'package:my_strengths/bloc/frequency_bloc.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
DateFormat daysFormat = DateFormat("dd-MM-yyyy");

class MyStrenghtsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DyanmicList();
  }
}

class DyanmicList extends State<MyStrenghtsList> {
  String _formattedDate;
  List<Frequency> frequencies;
  MyStrengthsBloc _myStrengthsBloc;
  FrequencyBloc _frequencyBloc = FrequencyBloc();

  final TextEditingController eCtrl = new TextEditingController();
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _initaliseNotificationPlugin();
    _formattedDate = daysFormat.format((DateTime.now()));
    _myStrengthsBloc = MyStrengthsBloc(_formattedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    var children2 = <Widget>[
      new Padding(
        padding: EdgeInsets.only(
          top: 20,
        ),
      ),
      new Row(
        //TODO: Put this in a container and manage the date properly for when i press calendar
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text(_formattedDate)],
      ),
      new Padding(
        padding: EdgeInsets.only(
          top: 20,
        ),
      ),
      new Expanded(
        child: getEntryList(),
      ),
      SizedBox(height: 25.0),
      _getInputContainer(),
      SizedBox(height: 25.0)
    ];
    return new Scaffold(
      appBar: MyAppBar(_handleDateChange),
      body: new Column(
        children: children2,
      ),
    );
  }

  void _processNewEntry(String text) async {
    Entry newEntry = _createNewEntry(text);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');

    frequencies = await _frequencyBloc.getFrequenciesNow();
    if (frequencies.isNotEmpty) {
      for (int i = 0; i < frequencies.length; i++) {
        await _scheduleNotification(name, newEntry, frequencies[i]);
      }
    }
  }

  void _scheduleNotification(String name, Entry entry, Frequency frequency) {
    String text = entry.description;
    String date = entry.date;

    final duration = frequency.duration;
    final type = frequency.timeType;

    if (type == 'D') {
      scheduleNotification(notifications,
          title: 'Congratulations $name!',
          body: 'You did well with $text on the $date',
          durationType: "days",
          duration: duration);
    } else if (type == 'W') {
      scheduleNotification(notifications,
          title: 'Congratulations $name!',
          body: 'You did well with $text on the $date',
          durationType: "weeks",
          duration: duration);
    } else {
      debugPrint("Didn't set notification");
    }
    return null;
  }

  Container _getInputContainer() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: new TextField(
        style: Theme.of(context).textTheme.body2,
        controller: eCtrl,
        onSubmitted: (String text) async {
          _processNewEntry(text);
        },
        decoration: InputDecoration(
            hintText: TextHelper.getPromptMessage(),
            hintStyle: Theme.of(context).textTheme.body2),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getEntryList() {
    return StreamBuilder(
      stream: _myStrengthsBloc.myStrengths,
      builder: (BuildContext context, AsyncSnapshot<List<Entry>> snapshot) {
        return getEntryWiget(snapshot);
      },
    );
  }

  Widget getEntryWiget(AsyncSnapshot<List<Entry>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Entry entry = snapshot.data[itemPosition];
                return EntryContainer(entry.description);
              },
            )
          : Container(
              child: Center(
              child: noTodoMessageWidget(),
            ));
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    _myStrengthsBloc.getStrengths(_formattedDate);
    return LoadingContainer();
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        "No entries for the selected date",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    _myStrengthsBloc.dispose();
  }

  void _initaliseNotificationPlugin() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  Entry _createNewEntry(String text) {
    String now = dateFormat.format(DateTime.now());
    String date = now.substring(0, 10);
    String time = now.substring(11, 19);
    Entry newEntry = Entry(text, date, time);
    _myStrengthsBloc.addStrength(newEntry, _formattedDate);
    eCtrl.clear();
    return newEntry;
  }

  void _handleDateChange(DateTime date) {
    setState(() {
      this._formattedDate = daysFormat.format(date);
    });
    _myStrengthsBloc.getStrengths(_formattedDate);
  }
}
