import 'package:dart_random_choice/dart_random_choice.dart';

class TextHelper {
  static String getPromptMessage() {
    var list = [
      'What went well today?',
      'How did you kick ass today?',
      'What are you proud of today?',
      'What dd you do well at today?',
    ];
    return randomChoice(list);
  }
}
