import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_strengths/utils/custom_notification_creator.dart';
import 'package:my_strengths/models/models.dart';
import 'package:my_strengths/ui/app_bar.dart';
import 'package:my_strengths/ui/custom/containers.dart';
import 'package:my_strengths/ui/custom/cards.dart';
import 'package:my_strengths/bloc/bloc.dart';
import 'package:my_strengths/utils/text_helper.dart';

DateFormat daysFormat = DateFormat("dd-MM-yyyy");

class MyStrenghtsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DyanmicList();
  }
}

class DyanmicList extends State<MyStrenghtsList> {
  String _formattedDate;
  EntryBloc _myEntryBloc;
  CustomNotificationCreator notificationCreator;
  InputDecoration _decoration;
  final _snackBar = SnackBar(
    content: Text('Undo Deletion!'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  InputDecoration _getDecorator() {
    return InputDecoration(
        hintText: TextHelper.getPromptMessage(),
        hintStyle: Theme.of(context).textTheme.body2);
  }

  void _handleDateChange(DateTime date) {
    setState(() {
      this._formattedDate = daysFormat.format(date);
    });
    _myEntryBloc.getEntries(_formattedDate);
  }

  void _handleNewEntry(String text) async {
    Entry newEntry = Entry(text, _formattedDate);
    _myEntryBloc.addEntry(newEntry, _formattedDate);
    notificationCreator.createNotifications(newEntry);
    setState(() {
      _decoration = _getDecorator();
    });
  }

  @override
  void initState() {
    notificationCreator = CustomNotificationCreator();
    _formattedDate = daysFormat.format(DateTime.now());
    _myEntryBloc = EntryBloc(_formattedDate);
    super.initState();
  }

  Column newColumn() {
    _decoration = _getDecorator();

    return new Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Entries"),
          Expanded(
            child: getEntryList(),
          ),
          StrengthInputContainer(_handleNewEntry, _decoration),
          // StrengthInputContainer(_handleNewEntry),
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
      stream: _myEntryBloc.myEntries,
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
                return Dismissible(
                  onDismissed: (DismissDirection direction) {
                    //TODO: implement a way to swipe and edit
                    if (direction == DismissDirection.endToStart) {
                      _myEntryBloc.deleteEntry(entry.id);
                      Scaffold.of(context).showSnackBar(_snackBar);
                    } else {
                      debugPrint("I want to edit the entry");
                    }
                    _myEntryBloc.getEntries(_formattedDate);
                  },
                  secondaryBackground: DeleteContainer(),
                  background: Container(),
                  child: EntryCard(entry.description),
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                );
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
    _myEntryBloc.getEntries(_formattedDate);
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
    _myEntryBloc.dispose();
  }
}
