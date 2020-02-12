import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

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

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);

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
