import 'dart:math';
import 'package:my_strengths/bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_strengths/models/models.dart';
import 'package:meta/meta.dart';

class CustomNotificationCreator {
  FlutterLocalNotificationsPlugin notifications;
  FrequencyBloc _frequencyBloc = FrequencyBloc();
  List<Frequency> frequencies;

  CustomNotificationCreator() {
    notifications = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    notifications.initialize(initializationSettings,
        onSelectNotification: null);
    print("notifications initalised");
  }

  void createNotifications(Entry entry) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const enabledPreferenceKey = 'enabled';
    bool switched = prefs.getBool(enabledPreferenceKey);

    if (switched != null) {
      String name = prefs.getString('name');

      frequencies = await _frequencyBloc.getFrequenciesNow();
      if (frequencies.isNotEmpty) {
        for (int i = 0; i < frequencies.length; i++) {
          await _createNotification(name, entry, frequencies[i].duration);
        }
      }
    } else {
      print("Notifications disabled");
    }
  }

  _createNotification(String name, Entry entry, int duration) {
    String text = entry.description;
    String date = entry.date;

    if (name == null) {
      name = "";
    }

    //TODO: Translate this

    scheduleNotification(notifications,
        title: 'Congratulations $name!',
        body: 'You did well with $text on the $date',
        duration: duration);
  }
}

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: true,
      autoCancel: true);
  final iOsChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOsChannelSpecifics);
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    notifications.show(id, title, body, _ongoing);

Future<void> scheduleNotification(FlutterLocalNotificationsPlugin notifications,
    {@required String title,
    @required String body,
    @required int duration}) async {
  final now = DateTime.now();
  final atMidnight = new DateTime(now.year, now.month, now.day);
  final randomHours = _getRandomTime(22, 8);
  final randomMins = _getRandomTime(60, 0);
  final scheduleTime = new DateTime(atMidnight.year, atMidnight.month,
      atMidnight.day + duration, randomHours, randomMins);

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Entry Reminder',
      'Entry Reminder',
      'Channel which reminds you of your entries');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await notifications.schedule(
      0, title, body, scheduleTime, platformChannelSpecifics);
  print("Scheduled notification for $scheduleTime");

  _showInstantNotificaiton(notifications, title, body);
}

_showInstantNotificaiton(FlutterLocalNotificationsPlugin notifications,
    String title, String body) async {
  //DEBUG Code for instantly showing notification

  var android = new AndroidNotificationDetails(
      'instant', 'instant notifications', 'instant notifications',
      priority: Priority.High, importance: Importance.Max);
  var iOS = new IOSNotificationDetails();
  var platform = new NotificationDetails(android, iOS);
  await notifications.show(0, title, body, platform);
}

_getRandomTime(int maximum, int minimum) {
  Random random = new Random();
  return random.nextInt(maximum) + minimum;
}
