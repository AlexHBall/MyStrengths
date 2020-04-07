import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_strengths/utils/custom_notification_creator.dart';
import 'package:my_strengths/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom/custom_ui.dart';
import 'package:my_strengths/bloc/bloc.dart';
import 'package:my_strengths/utils/utils.dart';

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
  TextEditingController _ectrl;

  InputDecoration _getDecorator() {
    return InputDecoration.collapsed(
      hintText: TextHelper.getPromptMessage(Localizations.localeOf(context)),
      hintStyle: Theme.of(context).textTheme.body2,
    );
  }

  void _showSnackBar(BuildContext context, Entry entry) {
    SnackBar snackBar = SnackBar(
      content: Text(AppLocalizations.of(context).translate("deleted_entry")),
      action: SnackBarAction(
        label: AppLocalizations.of(context).translate("delete_undo"),
        onPressed: () {
          entry.softDelete = 0;
          _myEntryBloc.updateEntry(entry);
          _myEntryBloc.getEntries(_formattedDate);
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _handleDateChange(DateTime date) {
    setState(() {
      this._formattedDate = daysFormat.format(date);
    });
    _myEntryBloc.getEntries(_formattedDate);
  }

  void _handleNewEntry(String text) async {
    Entry newEntry = Entry(text, _formattedDate, 'Default Input Text');
    _myEntryBloc.addEntry(newEntry, _formattedDate);
    notificationCreator.createNotifications(newEntry);
    setState(() {
      _decoration = _getDecorator();
    });
  }

  void _handleDirectionalSwipe(
      BuildContext context, DismissDirection direction, Entry entry) async {
    if (direction == DismissDirection.endToStart) {
      entry.softDelete = 1;
      _myEntryBloc.updateEntry(entry);
      _showSnackBar(context, entry);
    } else if (direction == DismissDirection.startToEnd) {
      _ectrl = new TextEditingController(text: entry.description);
      String editedText = await showDialog(
          context: context, builder: (context) => EditEntryDialog(_ectrl));
      if (editedText != null) {
        entry.description = editedText;
        _myEntryBloc.updateEntry(entry);
        _myEntryBloc.getEntries(_formattedDate);
      }
    }
  }

  @override
  void initState() {
    notificationCreator = CustomNotificationCreator();
    _formattedDate = daysFormat.format(DateTime.now());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _myEntryBloc = EntryBloc(_formattedDate);
    _myEntryBloc.getEntries(_formattedDate);
    super.didChangeDependencies();
  }

  Column listBody() {
    _decoration = _getDecorator();
    return new Column(children: <Widget>[
      // Text(
      //   AppLocalizations.of(context).translate('entries'),
      // ),
      Expanded(
        child: getEntryList(),
      ),
      StrengthInputContainer(_handleNewEntry, _decoration),
      SizedBox(height: 25.0),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: MainAppBar(_formattedDate, _handleDateChange),
      body: listBody(),
      //TODO: Remove this when onboarding done properly
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setBool("welcome", false);
        print("weclome ${prefs.getBool("welcome")}");
        },
      ),
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
                  onDismissed: (DismissDirection direction) async {
                    _handleDirectionalSwipe(context, direction, entry);
                  },
                  background: EditContainer(),
                  secondaryBackground: DeleteContainer(),
                  child: EntryCard(entry.description),
                  key: UniqueKey(),
                );
              },
            )
          : Container(child: Center(child: NoEntries()));
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

  dispose() {
    super.dispose();
    _myEntryBloc.dispose();
  }
}
