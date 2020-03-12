import 'package:my_strengths/bloc/frequency_bloc.dart';
import 'package:my_strengths/utils/notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_strengths/models/frequency.dart';
import 'package:my_strengths/models/entry.dart';

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
