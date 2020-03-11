import 'package:flutter/material.dart';
import 'settings.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function(DateTime) onDateSelected;

  MyAppBar(this.onDateSelected);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: new Text("My Strengths"),
      textTheme: Theme.of(context).textTheme,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            var date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              builder: (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                      // primarySwatch: buttonTextColor,//OK/Cancel button text color
                      primaryColor: const Color(0xFF4A5BF6), //Head background
                      accentColor: const Color(0xFF4A5BF6) //selection color
                      //dialogBackgroundColor: Colors.white,//Background color
                      ),
                  child: child,
                );
              },
            );
            if (date != null) {
              onDateSelected(date);
            }
          },
          // )
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Settings();
            }));
          },
        ),
      ],
    );
  }
}
