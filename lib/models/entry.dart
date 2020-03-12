class Entry {
  int _id;
  String _description;
  String _date;

  Entry(this._description, this._date);
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


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['description'] = _description;
    map['date'] = _date;
    return map;
  }

  Entry.fromMapObject(Map<String,dynamic> map){
    this._id = map['id'];
    this._description = map['description'];
    this._date = map['date'];
  }

@override String toString() {
  return "Entry with ID [$_id] Description [$_description] and date [$_date]";
  }
}
