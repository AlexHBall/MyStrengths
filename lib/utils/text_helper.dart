import 'dart:ui';

import 'package:dart_random_choice/dart_random_choice.dart';

class TextHelper {
  static String getPromptMessage(Locale locale) {
    List<String> englishList = [
      'What went well today?',
      'How did you kick ass today?',
      'What are you proud of today?',
      'What dd you do well at today?',
    ];

    List<String> frenchList = [
      "Qu'est-ce qui t'as rendu fier aujourd'hui ?",
      "Qu'est-ce qui t'as rendu heureux aujourd'hui ?",
      "Qu'est-ce qui s'est bien passé aujourd'hui ?",
      "Qu'est-ce que tu as accompli aujourd'hui ?"
    ];
    if (locale.languageCode == "en") {
      return randomChoice(englishList);
    } else if (locale.languageCode == "fr") {
      return randomChoice(frenchList);
    } else {
      return "Language not implemented";
    }
  }

  static String getNotificationTitle(Locale locale, String name) {
    if (locale.languageCode == "en") {
      return 'Congratulations $name!';
    } else if (locale.languageCode == "fr") {
      return 'Félicitations $name!';
    } else {
      return "Language not implemented";
    }
  }

  static String getNotificationBody(Locale locale, String text, String date) {
    if (locale.languageCode == "en") {
      return 'You did well with $text on the $date';
    } else if (locale.languageCode == "fr") {
      return 'Tu as fait bien avec $text sur $date';
    } else {
      return "Language not implemented";
    }
  }
}
