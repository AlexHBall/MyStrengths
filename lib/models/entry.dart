class Entry {
  int _id;
  String _description;
  String _date;
  String _time;

  Entry(this._description, this._date,this._time);
  Entry.withId(this._id, this._description, this._date,this._time);

  int get id => _id;
  String get description => _description;
  String get date => _date;
  String get time => _time;

  set entry(String newEntry) {
    this._description = newEntry;
  }

  set date(String newDate) {
    this._date = date;
  }

  set time(String newTime){
    this._time = time;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['description'] = _description;
    map['date'] = _date;
    map['time'] = _time;
    return map;
  }

  Entry.fromMapObject(Map<String,dynamic> map){
    this._id = map['id'];
    this._description = map['description'];
    this._date = map['date'];
    this._time = map['time'];
  }

@override String toString() {
  return "Entry with ID [$_id] Description [$_description] and date [$_date] at [$_time]";
  }
}
