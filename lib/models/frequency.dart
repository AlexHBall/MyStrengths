import 'dart:ui';

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

  String getNotificationString(Locale locale) {
    if (locale.languageCode == "en") {
      if (duration > 1) {
        return "$_duration days";
      }
      return " $_duration day";
    } else if (locale.languageCode == "fr") {
      if (duration > 1) {
        return "$_duration jours";
      }
      return " $_duration jour";
    } else {
      return "Language not implemented";
    }
  }
}
