import 'package:my_strengths/models/entry.dart';
import 'package:my_strengths/repository/repository.dart';

import 'dart:async';

class EntryBloc {
  final _entryRepository = EntryRepository();

  final _entryController = StreamController<List<Entry>>.broadcast();

  get myEntries => _entryController.stream;

  EntryBloc(String date) {
    getEntries(date);
  }

  getEntries(String date) async {
    _entryController.sink.add(await _entryRepository.getEntries(date));
  }

  addEntry(Entry entry, String date) async {
    await _entryRepository.insertEntry(entry);
    getEntries(date);
  }

  dispose() {
    _entryController.close();
  }

  deleteEntry(int id) async {
    await _entryRepository.deleteEntry(id);
  }
}
