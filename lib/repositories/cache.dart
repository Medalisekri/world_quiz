import 'package:hive_flutter/hive_flutter.dart';

class CacheRepository {
  static const String _countriesBoxName = 'countries_box';
  static const String _historyBoxName = 'history_box';
  static const String _settingsBoxName = 'app_box';

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(_countriesBoxName)) await Hive.openBox(_countriesBoxName);
    if (!Hive.isBoxOpen(_historyBoxName)) await Hive.openBox(_historyBoxName);
    if (!Hive.isBoxOpen(_settingsBoxName)) await Hive.openBox(_settingsBoxName);
  }

  Future<Box> _getSafeBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  Future<List<Map<String, dynamic>>?> getCachedCountries() async {
    final box = await _getSafeBox(_countriesBoxName);
    final data = box.get('countries_data');

    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }

    return null;
  }

  Future<void> saveCountries(List<Map<String, dynamic>> data) async {
    final box = await _getSafeBox(_countriesBoxName);
    await box.put('countries_data', data);
  }

  Future<List<dynamic>> getQuizHistory() async {
    final box = await _getSafeBox(_historyBoxName);
    final history = box.get('quiz_history', defaultValue: []);
    return history.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> saveQuizResult(Map<String, dynamic> result) async {
    final box = await _getSafeBox(_historyBoxName);
    final history = await getQuizHistory();
    history.insert(0, result);
    if (history.length > 5) history.removeLast();
    await box.put('quiz_history', history);
  }
}