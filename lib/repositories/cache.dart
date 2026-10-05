import 'package:hive_flutter/hive_flutter.dart';

class CacheRepository {
  static const String _countriesBoxName = 'countries_box';
  static const String _historyBoxName = 'history_box';

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(_countriesBoxName)) {
      await Hive.openBox(_countriesBoxName);
    }
    if (!Hive.isBoxOpen(_historyBoxName)) {
      await Hive.openBox(_historyBoxName);
    }
  }

  Future<List<Map<String, dynamic>>?> getCachedCountries() async {
    final box = Hive.box(_countriesBoxName);
    final data = box.get('countries_data');
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return null;
  }

  Future<void> saveCountries(List<Map<String, dynamic>> data) async {
    final box = Hive.box(_countriesBoxName);
    await box.put('countries_data', data);
  }

  Future<List<Map<String, dynamic>>> getQuizHistory() async {
    final box = Hive.box(_historyBoxName);
    final history = box.get('quiz_history', defaultValue: []);
    return List<Map<String, dynamic>>.from(history);
  }

  Future<void> saveQuizResult(Map<String, dynamic> result) async {
    final box = Hive.box(_historyBoxName);
    final history = await getQuizHistory();

    history.insert(0, result); // Add newest to the top
    if (history.length > 5) {
      history.removeLast(); // Keep only the last 5
    }

    await box.put('quiz_history', history);
  }
}