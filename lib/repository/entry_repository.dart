import 'package:my_strengths/doa/data_access_object.dart';
import 'package:my_strengths/models/models.dart';

class EntryRepository {
  final myStrengthsDao = MyStrengthsDao();
  Future getEntries(String date) => myStrengthsDao.getEntriesOnDate(date);
  Future insertEntry(Entry entry) => myStrengthsDao.insertEntry(entry);
  Future updateEntry(Entry entry) => myStrengthsDao.updateEntry(entry);
}
