import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_strengths/ui/home.dart';
import 'package:my_strengths/utils/utils.dart';
import 'utils/theme.dart';

void main() {
  runApp(MyStrengths());
}

class MyStrengths extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: basicTheme(),
      //TODO: Spash screen for android
      //https://flutter.dev/docs/development/ui/splash-screen/android-splash-screen

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
        var retLocale = supportedLocales.first;
        // Check if the current device locale is supported
        if (locale != null) {
          print("user locale ${locale.languageCode}, ${locale.countryCode}");
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              retLocale = supportedLocale;
              if (supportedLocale.countryCode == locale.countryCode) {
                break;
              }
            }
          }
        }

        return retLocale;
      },
      home: Home(),
    );
  }
}
