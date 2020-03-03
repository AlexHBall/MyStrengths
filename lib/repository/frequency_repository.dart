import 'package:my_strengths/doa/data_access_object.dart';
import 'package:my_strengths/models/frequency.dart';

class FrequencyRepository {
  final myStrengthsDao = MyStrengthsDao();
  Future getFrequencies() => myStrengthsDao.getFrequencyList();
  Future insertFrequency(Frequency frequency) => myStrengthsDao.insertFrequency(frequency);
  Future deleteFrequency(int id) => myStrengthsDao.deleteFrequency(id);
}
