import 'package:flutter/material.dart';
import 'settings.dart';

class MyAppBar {
  appBar(BuildContext context) {
    return new AppBar(
      title: new Text("My Strengths"),
      textTheme: Theme.of(context).textTheme,
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      actions: <Widget>[
        // Theme(
        // data: ThemeData.light(),
        // child:
        IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () {
            var date = showDatePicker(
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
          },
          // )
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return Settings();
            // }
            // )
            // );
          },
        ),
      ],
    );
  }
}
