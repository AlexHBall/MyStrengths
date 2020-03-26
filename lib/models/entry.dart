import 'package:intl/intl.dart';

class Entry {
  DateFormat daysFormat = DateFormat("dd-MM-yyyy");

  int _id;
  String _description;
  String _date;
  String _inputText;
  int _softDelete = 0;

  Entry(this._description, this._date, this._inputText);
  Entry.withId(this._id, this._description, this._date);

  int get id => _id;
  String get description => _description;
  String get date => _date;

  set entry(String newEntry) {
    this._description = newEntry;
  }

  set date(String newDate) {
    this._date = date;
  }

  set softDelete(int deleted) {
    if (deleted == 0 || deleted == 1) {
      this._softDelete = deleted;
    }
  }

  get softDelete {
    return this._softDelete;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['description'] = _description;
    map['date'] = _date;
    map['inputText'] = _inputText;
    map['softDelete'] = _softDelete;
    return map;
  }

  Entry.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._description = map['description'];
    this._date = map['date'];
    this._inputText = map['inputText'];
    this._softDelete = map['softDelete'];
  }

  DateTime getDateTime() {
    return daysFormat.parse(date);
  }

  @override
  String toString() {
    return "Entry with ID [$_id] Description [$_description] and date [$_date]";
  }
}
