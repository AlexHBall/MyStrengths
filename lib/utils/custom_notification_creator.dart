import 'dart:math';
import 'package:my_strengths/bloc/frequency_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_strengths/models/frequency.dart';
import 'package:my_strengths/models/entry.dart';
import 'package:meta/meta.dart';

class CustomNotificationCreator {
  final notifications = FlutterLocalNotificationsPlugin();
  FrequencyBloc _frequencyBloc = FrequencyBloc();
  List<Frequency> frequencies;

  CustomNotificationCreator() {
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

// Future _showNotification(
//Instantly show a notification
//   FlutterLocalNotificationsPlugin notifications, {
//   @required String title,
//   @required String body,
//   @required NotificationDetails type,
//   int id = 0,
// }) =>
//     notifications.show(id, title, body, type);

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
      // What are these and why do they matter?
      'your other channel id',
      'your other channel name',
      'your other channel description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await notifications.schedule(
      0, title, body, scheduleTime, platformChannelSpecifics);
  print("Scheduled notification for $scheduleTime");
}

_getRandomTime(int maximum, int minimum) {
  Random random = new Random();
  return random.nextInt(maximum) + minimum;
}
