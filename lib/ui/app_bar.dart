import 'package:flutter/material.dart';
import 'package:my_strengths/ui/custom_calendar.dart';
import 'package:my_strengths/doa/data_access_object.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function(DateTime) onDateSelected;
  final String date;
  MyAppBar(this.date, this.onDateSelected);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Future<bool> _getVisible(SharedPreferences prefs) async {
    const enabledPreferenceKey = 'enabled';
    bool switched = prefs.getBool(enabledPreferenceKey);
    if (switched != null) {
      return switched;
    }
    return false;
  }

  Future<String> _getName(SharedPreferences prefs) async {
    const namePreferenceKey = 'name';
    return prefs.getString(namePreferenceKey);
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
                return CalendarScreen(eventList);
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
            String name = await _getName(prefs);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Settings(switched, name);
            }));
          },
        ),
      ],
    );
  }
}
