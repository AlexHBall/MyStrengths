import 'package:my_strengths/doa/data_access_object.dart';
import 'package:my_strengths/models/frequency.dart';

class FrequencyRepository {
  final myStrengthsDao = MyStrengthsDao();
  Future getFrequencies() => myStrengthsDao.getFrequencyList();
  Future insertFrequency(Frequency frequency) =>
      myStrengthsDao.insertFrequency(frequency);
  Future updateFrequency(Frequency frequency) =>
      myStrengthsDao.updateFrequency(frequency);
  Future deleteFrequency(int id) => myStrengthsDao.deleteFrequency(id);
}
