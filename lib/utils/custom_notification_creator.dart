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
    String name = prefs.getString('name');

    frequencies = await _frequencyBloc.getFrequenciesNow();
    if (frequencies.isNotEmpty) {
      for (int i = 0; i < frequencies.length; i++) {
        await _createNotification(name, entry, frequencies[i]);
      }
    }
  }

  Future _createNotification(String name, Entry entry, Frequency frequency) {
    String text = entry.description;
    String date = entry.date;

    final duration = frequency.duration;
    final type = frequency.timeType;

    //TODO: Change the times here so they are random 
    //throughout the day of the scheduled notification
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
      // debugPrint("Didn't set notification");
    }
    return null;
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
    @required String durationType,
    @required int duration}) async {
  var scheduledNotificationDateTime;
  if (durationType == "hours") {
    scheduledNotificationDateTime =
        DateTime.now().add(Duration(hours: duration));
  } else if (durationType == "seconds") {
    scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: duration));
  } else if (durationType == "days") {
    scheduledNotificationDateTime =
        DateTime.now().add(Duration(days: duration));
  }
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await notifications.schedule(
      0, title, body, scheduledNotificationDateTime, platformChannelSpecifics);
  print("Scheduled notification for $duration $durationType");
}
