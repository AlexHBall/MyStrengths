class Frequency {
  int _id;
  int _duration;
  Frequency(this._duration);

  int get id => _id;
  int get duration => _duration;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['duration'] = _duration;
    return map;
  }

  Frequency.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._duration = map['duration'];
  }

  set duration(int duration) {
    this._duration = duration;
  }

  @override
  String toString() {
    return "Frequency with ID [$_id] and duration [$_duration]";
  }

  String getNotificationString() {
    if (duration > 1) {
      return "Entry Reminder in $_duration days";
    }
    return "Entry Reminder in $_duration day";
  }
}
