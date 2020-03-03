// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dialogs/dialogs.dart';
// import '../models/frequency.dart';
// import '../utils/database_helper.dart';

// import 'package:sqflite/sqflite.dart';

// class Settings extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return SettingsState();
//   }
// }

// class SettingsState extends State<Settings> {
//   bool isSwitched = false;
//   final TextEditingController eCtrl = new TextEditingController();
//   DatabaseHelper dbHelper = DatabaseHelper();
//   List<Frequency> frequencyList;
//   int count = 0;

//   static const namePreferenceKey = 'name';
//   static const enabledPreferenceKey = 'enabled';
//   SharedPreferences prefs;
//   String oldName;

//   void showNotifications() async {
//     debugPrint('isSwitched $isSwitched');
//     prefs = await SharedPreferences.getInstance();
//     prefs.setBool(enabledPreferenceKey, isSwitched);
//   }

//   @override
//   void initState() {
//     super.initState();
//     dbHelper.initializeDatabase();
//     _getPreferences();
//   }

//   _getPreferences() async {
//     prefs = await SharedPreferences.getInstance();
//     String name = prefs.getString(namePreferenceKey);
//     if (name != null) {
//       oldName = name;
//       setState(() {});
//     }
//     bool switched = prefs.getBool(enabledPreferenceKey);
//     debugPrint('Switched $switched');
//     setState(() {
//       isSwitched = switched;
//     });
//   }

//   @override
//   build(BuildContext context) {
//     if (frequencyList == null) {
//       frequencyList = List<Frequency>();
//       updateListView();
//     }
//     Dialogs dialog = new Dialogs();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Settings"),
//       ),
//       body: Column(children: <Widget>[
//         _getNameRow(),
//         _getSwitchRow(),
//         SizedBox(
//           height: 20,
//         ),
//         Visibility(
//             visible: isSwitched,
//             child: new Expanded(
//                 child: new ListView.builder(
//                     itemCount: frequencyList.length,
//                     itemBuilder: (BuildContext ctxt, int index) {
//                       return new GestureDetector(
//                         onTap: () async {
//                           final delete = await dialog.deleteDialog(context);
//                           if (delete) {
//                             await dbHelper
//                                 .deleteFrequency(frequencyList[index].id);
//                             setState(() {
//                               updateListView();
//                             });
//                           }
//                         },
//                         child: new Text(
//                           frequencyList[index].getNotificationString(),
//                           style: Theme.of(context).textTheme.body2,
//                         ),
//                       );
//                     }))),
//       ]),
//       floatingActionButton: Visibility(
//         visible: isSwitched,
//         child: FloatingActionButton.extended(
//           onPressed: () async {
//             final Frequency result = await dialog.frequencyDialog(context);
//             await dbHelper.insertFrequency(result);
//             setState(() {
//               updateListView();
//             });
//             debugPrint('result $result');
//           },
//           label: Text('Add new notification'),
//           icon: Icon(Icons.add_alarm),
//           backgroundColor: Colors.blueAccent,
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   void updateListView() {
//     final Future<Database> dbFuture = dbHelper.initializeDatabase();
//     dbFuture.then((database) {
//       Future<List<Frequency>> frequencyListFuture = dbHelper.getFrequencyList();
//       frequencyListFuture.then((entryList) {
//         setState(() {
//           this.frequencyList = entryList;
//           this.count = entryList.length;
//         });
//       });
//     });
//   }

//   Row _getNameRow() {
//     return new Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           'What is your name?',
//           style: Theme.of(context).textTheme.body2,
//         ),
//         new Flexible(child: _getNameField()),
//       ],
//     );
//   }

//   Row _getSwitchRow() {
//     return new Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Text(
//           'Enable notifications',
//           style: Theme.of(context).textTheme.body2,
//         ),
//         Switch(
//           value: isSwitched,
//           onChanged: (value) {
//             setState(() {
//               isSwitched = value;
//               showNotifications();
//             });
//           },
//           activeTrackColor: Colors.lightBlueAccent,
//           activeColor: Colors.blue,
//         ),
//       ],
//     );
//   }

//   TextField _getNameField() {
//     return new TextField(
//       controller: eCtrl,
//       decoration: InputDecoration(
//         hintText: oldName,
//         hintStyle: Theme.of(context).textTheme.body2,
//       ),
//       textAlign: TextAlign.center,
//       onSubmitted: (String text) async {
//         if (prefs == null) {
//           prefs = await SharedPreferences.getInstance();
//         }
//         await prefs.setString(namePreferenceKey, text);
//       },
//     );
//   }
// }
