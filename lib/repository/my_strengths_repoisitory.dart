import 'package:my_strengths/doa/data_access_object.dart';
import 'package:my_strengths/models/entry.dart';

class MyStrengthsRepository {
  final myStrengthsDao = MyStrengthsDao();
  Future getStrengths(String date) => myStrengthsDao.getStrengthsOnDate(date);
  Future insertEntry(Entry entry) => myStrengthsDao.insertEntry(entry);
}
