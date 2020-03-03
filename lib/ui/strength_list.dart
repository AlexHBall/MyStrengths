import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_strengths/models/frequency.dart';
import 'package:my_strengths/models/entry.dart';
import 'package:my_strengths/ui/app_bar.dart';
import 'package:my_strengths/ui/containers/entry_container.dart';
import 'package:my_strengths/utils/text_helper.dart';
import 'package:my_strengths/utils/notification_helper.dart';
import 'package:my_strengths/bloc/my_strengths_bloc.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");

class MyStrenghtsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DyanmicList();
  }
}

class DyanmicList extends State<MyStrenghtsList> {
  List<Frequency> frequencies;
  int count = 0;
  MyStrengthsBloc _myStrengthsBloc = MyStrengthsBloc();
  final TextEditingController eCtrl = new TextEditingController();

  final notifications = FlutterLocalNotificationsPlugin();

  MyAppBar myAppBar = new MyAppBar();
  EntryContainer entryContainer = new EntryContainer();
  @override
  void initState() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    // _getFrequencies();

    super.initState();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print(payload);
    }
  }

  @override
  Widget build(BuildContext ctxt) {
    var children2 = <Widget>[
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
      appBar: myAppBar.appBar(context),
      body: new Column(
        children: children2,
      ),
    );
  }

  void _processNewEntry(String text) async {
    String now = dateFormat.format(DateTime.now());
    String date = now.substring(0, 10);
    String time = now.substring(11, 19);
    Entry newEntry = Entry(text, date, time);
    _myStrengthsBloc.addStrength(newEntry);
    eCtrl.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    // await _scheduleNotifications(name, newEntry, frequencies);
  }

  void _scheduleNotifications(
      String name, Entry entry, List<Frequency> frequencies) {
    //TODO: Tidy this the fuck up, could be smoother
    String text = entry.description;
    String date = entry.date;
    for (final e in frequencies) {
      final duration = e.duration;
      final type = e.timeType;

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
            // border: OutlineInputBorder(),
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
                return entryContainer.entryContainer(context, entry.description);
              },
            )
          : Container(
              child: Center(
              //this is used whenever there 0 Todo
              //in the data base
              child: noTodoMessageWidget(),
            ));
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    _myStrengthsBloc.getMyStrengths();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        "Start adding Todo...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    _myStrengthsBloc.dispose();
  }
}
