import 'dart:math';
import 'dart:ui';
import 'package:my_strengths/bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_strengths/utils/utils.dart';
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

  void createNotifications(Entry entry, Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const enabledPreferenceKey = 'enabled';
    bool switched = prefs.getBool(enabledPreferenceKey);

    if (switched == true) {
      String title = TextHelper.getNotificationTitle(locale, _getName(prefs));
      String body =
          TextHelper.getNotificationBody(locale, entry.description, entry.date);

      frequencies = await _frequencyBloc.getFrequenciesNow();
      if (frequencies.isNotEmpty) {
        for (int i = 0; i < frequencies.length; i++) {
          await _createNotification(title, body, frequencies[i].duration);
        }
      }
    } else {
      print("Notifications disabled");
    }
  }

  String _getName(SharedPreferences prefs) {
    String name = prefs.getString('name');

    if (name == null) {
      return "";
    }
    return name;
  }

  _createNotification(String title, String body, int duration) {
    scheduleNotification(notifications,
        title: title, body: body, duration: duration);
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
  DateTime scheduledTime = _getScheduledTime(duration);
  await notifications.schedule(0, title, body, scheduledTime, _getDetails());
  print("Scheduled notification for $scheduledTime \ntitle [$title] \nbody [$body]");

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

DateTime _getScheduledTime(int duration) {
  final now = DateTime.now();
  final randomHours = _getRandomTime(22, 8);
  final randomMins = _getRandomTime(60, 0);
  final scheduleTime = new DateTime(
      now.year, now.month, now.day + duration, randomHours, randomMins);
  print(
      "Duration [$duration] Now [${now.day}] Scheduled [${scheduleTime.day}]");
  return scheduleTime;
}

NotificationDetails _getDetails() {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Entry Reminder',
      'Entry Reminder',
      'Channel which reminds you of your entries');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
}

int _getRandomTime(int maximum, int minimum) {
  Random random = new Random();
  return minimum + random.nextInt(maximum - minimum);
}
