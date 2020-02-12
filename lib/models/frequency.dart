class Frequency {
  int _id;
  String _timeType;
  int _duration;
  Frequency(this._timeType, this._duration);

  int get id => _id;
  String get timeType => _timeType;
  int get duration => _duration;

  String getTimeText(){
    if (this._timeType == 'D'){
      return 'day(s)';
    } else if (this._timeType == 'W'){
      return 'week(s)';
    }
    return null;
  }


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['timeType'] = _timeType;
    map['duration'] = _duration;
    return map;
  }

  Frequency.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._timeType = map['timeType'];
    this._duration = map['duration'];
  }

  @override
  String toString() {
    return "Frequency with ID [$_id] timeType [$_timeType] and duration [$_duration]";
  }
}
