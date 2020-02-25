import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_strengths/models/frequency.dart';
import '../models/entry.dart';
import '../utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'containers/entry_container.dart';
import 'settings.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_strengths/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_bar.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");

class MyStrenghtsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DyanmicList();
  }
}

class DyanmicList extends State<MyStrenghtsList> {
  List<Entry> entryList;
  List<Frequency> frequencies;
  int count = 0;
  DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController eCtrl = new TextEditingController();

  final notifications = FlutterLocalNotificationsPlugin();

  MyAppBar myAppBar = new MyAppBar();
  EntryContainer entryContainer = new EntryContainer();
  @override
  void initState() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _getFrequencies();

    super.initState();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print(payload);
    }
  }

  @override
  Widget build(BuildContext ctxt) {
    if (entryList == null) {
      entryList = List<Entry>();
      updateListView();
    }

    return new Scaffold(
      appBar: myAppBar.appBar(context),
      body: new Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          new Expanded(
            child: new ListView.builder(
                itemCount: entryList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return entryContainer.entryContainer(context,
                      entryList[index].description);
                }),
          ),
          new Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: new TextField(
              style: Theme.of(context).textTheme.body2,
              controller: eCtrl,
              onSubmitted: (String text) async {
                _processNewEntry(text);
              },
              decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: "Today I did really well",
                  hintStyle: Theme.of(context).textTheme.body2),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 25.0)
        ],
      ),
    );
  }

  void _processNewEntry(String text) async {
    String now = dateFormat.format(DateTime.now());
    String date = now.substring(0, 10);
    String time = now.substring(11, 19);
    Entry newEntry = Entry(text, date, time);
    entryList.add(newEntry);

    debugPrint("Adding entry $newEntry to db");
    dbHelper.insertEntry(newEntry);

    eCtrl.clear();
    setState(() {});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    await _scheduleNotifications(name, newEntry, frequencies);
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Entry>> entryListFuture = dbHelper.getTodaysList();
      entryListFuture.then((entryList) {
        setState(() {
          this.entryList = entryList;
          this.count = entryList.length;
        });
      });
    });
  }

  void _scheduleNotifications(
      String name, Entry entry, List<Frequency> frequencies) {
    //TODO: Tidy this the fuck up, could be smoother
    String text = entry.description;
    String date = entry.date;
    for (final e in frequencies) {
      final duration = e.duration;
      final type = e.timeType;

      debugPrint("Attempting to set notification for $duration $type for $e");

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

  Future _getFrequencies() async {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Frequency>> frequencyListFuture = dbHelper.getFrequencyList();
      frequencyListFuture.then((frequencyList) {
        setState(() {
          this.frequencies = frequencyList;
        });
      });
    });
  }
}
