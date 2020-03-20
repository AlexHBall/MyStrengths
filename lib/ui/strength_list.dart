import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_strengths/utils/custom_notification_creator.dart';
import 'package:my_strengths/models/entry.dart';
import 'package:my_strengths/ui/app_bar.dart';
import 'package:my_strengths/ui/custom/containers.dart';
import 'package:my_strengths/ui/custom/cards.dart';
import 'package:my_strengths/bloc/bloc.dart';

DateFormat daysFormat = DateFormat("dd-MM-yyyy");

class MyStrenghtsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DyanmicList();
  }
}

class DyanmicList extends State<MyStrenghtsList> {
  String _formattedDate;
  EntryBloc _myStrengthsBloc;
  CustomNotificationCreator notificationCreator;

  void _handleDateChange(DateTime date) {
    setState(() {
      this._formattedDate = daysFormat.format(date);
    });
    _myStrengthsBloc.getEntries(_formattedDate);
  }

  void _handleNewEntry(String text) async {
    Entry newEntry = Entry(text, _formattedDate);
    _myStrengthsBloc.addEntry(newEntry, _formattedDate);
    notificationCreator.createNotifications(newEntry);
  }

  @override
  void initState() {
    notificationCreator = CustomNotificationCreator();
    _formattedDate = daysFormat.format(DateTime.now());
    _myStrengthsBloc = EntryBloc(_formattedDate);
    super.initState();
  }

  Column newColumn() {
    return new Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Entries"),
          Expanded(
            child: getEntryList(),
          ),
          StrengthInputContainer(_handleNewEntry),
          SizedBox(height: 25.0),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: MyAppBar(_formattedDate, _handleDateChange),
      body: newColumn(),
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
                return EntryCard(entry.description);
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
    _myStrengthsBloc.getEntries(_formattedDate);
    return LoadingContainer();
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        "No entries yet",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    super.dispose();
    _myStrengthsBloc.dispose();
  }
}
