import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_strengths/utils/custom_notification_creator.dart';
import 'package:my_strengths/models/entry.dart';
import 'package:my_strengths/ui/app_bar.dart';
import 'package:my_strengths/ui/containers/containers.dart';
import 'package:my_strengths/utils/text_helper.dart';
import 'package:my_strengths/bloc/my_strengths_bloc.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
DateFormat daysFormat = DateFormat("dd-MM-yyyy");

class MyStrenghtsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DyanmicList();
  }
}

class DyanmicList extends State<MyStrenghtsList> {
  String _formattedDate;
  MyStrengthsBloc _myStrengthsBloc;
  CustomNotificationCreator notificationCreator;

  void _handleDateChange(DateTime date) {
    setState(() {
      this._formattedDate = daysFormat.format(date);
    });
    _myStrengthsBloc.getStrengths(_formattedDate);
  }

  void _handleNewEntry(String text) async {
    Entry newEntry = _createNewEntry(text);
    notificationCreator.createNotifications(newEntry);
  }

  @override
  void initState() {
    notificationCreator = CustomNotificationCreator();
    _formattedDate = daysFormat.format(DateTime.now());
    _myStrengthsBloc = MyStrengthsBloc(_formattedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    var children2 = <Widget>[
      new Padding(
        padding: EdgeInsets.only(
          top: 20,
        ),
      ),
      new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text(_formattedDate)],
      ),
      new Padding(
        padding: EdgeInsets.only(
          top: 20,
        ),
      ),
      new Expanded(
        child: getEntryList(),
      ),
      SizedBox(height: 25.0),
      InputContainer(_handleNewEntry),
      SizedBox(height: 25.0)
    ];
    return new Scaffold(
      appBar: MyAppBar(_handleDateChange),
      body: new Column(
        children: children2,
      ),
    );
  }

  Widget getEntryList() {
    return StreamBuilder(
      stream: _myStrengthsBloc.myStrengths,
      builder: (BuildContext context, AsyncSnapshot<List<Entry>> snapshot) {
        return getEntryWiget(snapshot);
      },
    );
  }

  Widget getEntryWiget(AsyncSnapshot<List<Entry>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Entry entry = snapshot.data[itemPosition];
                return EntryContainer(entry.description);
              },
            )
          : Container(
              child: Center(
              child: noTodoMessageWidget(),
            ));
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    _myStrengthsBloc.getStrengths(_formattedDate);
    return LoadingContainer();
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        "No entries on $_formattedDate",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    _myStrengthsBloc.dispose();
  }

  Entry _createNewEntry(String text) {
    String date = _formattedDate;
    Entry newEntry = Entry(text, date);
    _myStrengthsBloc.addStrength(newEntry, _formattedDate);
    return newEntry;
  }
}
