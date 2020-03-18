import 'package:flutter/material.dart';
import 'package:my_strengths/ui/custom_calendar.dart';
import 'settings.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function(DateTime) onDateSelected;
  final String date;
  MyAppBar(this.date, this.onDateSelected);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

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
            var date = await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CalendarScreen();
            }));
            print("Date $date");
            if (date != null) {
              onDateSelected(date);
            }
          }
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            //TODO: New page where you can see the date like this
            // https://dribbble.com/shots/8929931-FitKiddo-Mobile-App-Home-Stats
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Settings();
            }));
          },
        ),
      ],
    );
  }
}
