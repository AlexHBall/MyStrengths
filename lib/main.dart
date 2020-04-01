import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_strengths/app_localisations.dart';
import 'ui/strength_list.dart';
import 'utils/theme.dart';

void main() {
  runApp(MyStrengths());
}

class MyStrengths extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: basicTheme(),
      // debugShowCheckedModeBanner: false  ,
      supportedLocales: [
        Locale('en', 'UK'),
        Locale('fr', 'FR'),
      ],
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode ||
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: MyStrenghtsList(),
    );
  }
}
