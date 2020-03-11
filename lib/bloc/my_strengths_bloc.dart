import 'package:my_strengths/models/entry.dart';
import 'package:my_strengths/repository/my_strengths_repoisitory.dart';

import 'dart:async';

class MyStrengthsBloc {
  final _myStrengthsRepository = MyStrengthsRepository();

  final _myStrengthsController = StreamController<List<Entry>>.broadcast();

  get myStrengths => _myStrengthsController.stream;

  MyStrengthsBloc() {
    getTodaysMyStrengths();
  }

  getTodaysMyStrengths() async {
    _myStrengthsController.sink
        .add(await _myStrengthsRepository.getTodaysStrengths());
  }

  addStrength(Entry entry) async {
    await _myStrengthsRepository.insertEntry(entry);
    getTodaysMyStrengths();
  }

  dispose() {
    _myStrengthsController.close();
  }
}
