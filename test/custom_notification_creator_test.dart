import 'package:test/test.dart';
import 'package:my_strengths/models/models.dart';
import 'package:my_strengths/utils/custom_notification_creator.dart';


void main() {
  test('Counter value should be incremented', () {
    final counter = CustomNotificationCreator();
    final entry =Entry("heello", "date", "text");
    counter.createNotifications(entry);


    // expect(counter.value, 1);
  });
}