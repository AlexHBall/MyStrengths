import 'package:my_strengths/models/frequency.dart';
import 'package:my_strengths/repository/frequency_repository.dart';

import 'dart:async';

class FrequencyBloc {
  final _frequencyRepository = FrequencyRepository();

  final _frequencyController = StreamController<List<Frequency>>.broadcast();

  get frequency => _frequencyController.stream;

  frequencyBloc() {
    getFrequencies();
  }

  getFrequencies() async {
    _frequencyController.sink.add(await _frequencyRepository.getFrequencies());
  }

  getFrequenciesNow() async {
    return _frequencyRepository.getFrequencies();
  }

  addFrequency(Frequency frequency) async {
    await _frequencyRepository.insertFrequency(frequency);
    getFrequencies();
  }

  deleteFrequency(int id) async {
    await _frequencyRepository.deleteFrequency(id);
    getFrequencies();
  }

  dispose() {
    _frequencyController.close();
  }
}
