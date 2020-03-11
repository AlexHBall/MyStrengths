import 'package:my_strengths/models/entry.dart';
import 'package:my_strengths/repository/my_strengths_repoisitory.dart';

import 'dart:async';

class MyStrengthsBloc {
  final _myStrengthsRepository = MyStrengthsRepository();

  final _myStrengthsController = StreamController<List<Entry>>.broadcast();

  get myStrengths => _myStrengthsController.stream;

  MyStrengthsBloc(String date) {
    getStrengths(date);
  }

  getStrengths(String date) async {
    _myStrengthsController.sink
        .add(await _myStrengthsRepository.getStrengths(date));
  }

  addStrength(Entry entry, String date) async {
    await _myStrengthsRepository.insertEntry(entry);
    getStrengths(date);
  }

  dispose() {
    _myStrengthsController.close();
  }
}
