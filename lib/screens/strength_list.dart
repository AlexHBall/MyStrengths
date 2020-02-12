import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_strengths/models/frequency.dart';
import '../models/entry.dart';
import '../utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'settings.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_strengths/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        appBar: new AppBar(
          title: new Text("My Strengths"),
        ),
        body: new Column(
          children: <Widget>[
            new Expanded(
                child: new ListView.builder(
                    itemCount: entryList.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Text(entryList[index].description);
                    })),
            new TextField(
              controller: eCtrl,
              onSubmitted: (String text) async {
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
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Today I did really well"),
              textAlign: TextAlign.center,
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: _getRowBar(),
        ));
  }

  Row _getRowBar() {
    return Row(children: <Widget>[
      Expanded(
          child: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Settings();
          }));
        },
      )),
    ]);
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

  Future<void> _scheduleNotifications(
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
