import 'package:flutter/material.dart';
import 'package:my_strengths/ui/custom/custom_ui.dart';
import 'package:my_strengths/doa/data_access_object.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:my_strengths/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_strengths/ui/settings.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function(DateTime) onDateSelected;
  final String date;
  final String enabledPreferenceKey = 'enabled';
  final String namePreferenceKey = 'name';

  MainAppBar(this.date, this.onDateSelected);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Future<bool> _getVisible(SharedPreferences prefs) async {
    bool switched = prefs.getBool(enabledPreferenceKey);
    if (switched != null) {
      return switched;
    }
    return false;
  }

  Future<String> _getStringPref(SharedPreferences prefs, String key) async {
    String pref = prefs.getString(key);
    if (pref != null) {
      return pref;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: new Text(date),
      textTheme: Theme.of(context).textTheme,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () async {
              MyStrengthsDao dao = MyStrengthsDao();
              List<DateTime> dates = await dao.getUniqueDates();
              EventList<Event> eventList = EventList<Event>();

              for (int i = 0; i < dates.length; i++) {
                Event event = new Event(date: dates[i]);
                eventList.add(dates[i], event);
              }

              var date = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return CalendarScreen(
                    eventList, Localizations.localeOf(context));
              }));
              if (date != null) {
                onDateSelected(date);
              }
            }),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool switched = await _getVisible(prefs);
            String name = await _getStringPref(prefs, namePreferenceKey);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Settings(switched, name);
            }));
          },
        ),
      ],
    );
  }
}

class OnboardAppBar extends StatelessWidget with PreferredSizeWidget {
  final String welcomePreferenceKey = 'welcome';

  OnboardAppBar();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Future<void> _skipOnboard(SharedPreferences prefs) async {
    prefs.setBool(welcomePreferenceKey, true);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(actions: <Widget>[
      FlatButton(
        child: Text(
          AppLocalizations.of(context).translate('onboard_skip'),
        ),
        textColor: Colors.white,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          _skipOnboard(prefs);
          Navigator.pushNamedAndRemoveUntil(context, "/strengths",
              (Route<dynamic> route) {
            return false;
          });
        },
      ),
    ]);
  }
}
