import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// translations map
const Map<String, Map<String, String>> translations = {
  'en': {
    'app_title': 'WorldQuiz',
    'quiz': 'Quiz',
    'country_detail': 'Country Detail',
    'capital': 'Capital',
    'continent': 'Continent',
    'population': 'Population',
    'languages': 'Languages',
    'currencies': 'Currencies',
    'quiz_setup': 'Quiz Setup',
    'difficulty': 'Difficulty',
    'easy': 'Easy',
    'medium': 'Medium',
    'hard': 'Hard',
    'start_quiz': 'START QUIZ',
    'play_again': 'PLAY AGAIN',
    'back_to_home': 'Back to Home',
    'genius': 'Genius! 🧠',
    'good_job': 'Good Job! 👍',
    'keep_practicing': 'Keep Practicing! 💪',
    'max_streak': 'Max Streak',
    "error": "Failed to load countries"
  },
  'ar': {
    'app_title': 'كويز العالم',
    'quiz': 'اختبار',
    'country_detail': 'تفاصيل الدولة',
    'capital': 'العاصمة',
    'continent': 'القارة',
    'population': 'عدد السكان',
    'languages': 'اللغات',
    'currencies': 'العملات',
    'quiz_setup': 'إعداد الاختبار',
    'difficulty': 'الصعوبة',
    'easy': 'سهل',
    'medium': 'متوسط',
    'hard': 'صعب',
    'start_quiz': 'ابدأ الاختبار',
    'play_again': 'العب مرة أخرى',
    'back_to_home': 'العودة للرئيسية',
    'genius': 'عبقري! 🧠',
    'good_job': 'عمل رائع! 👍',
    'keep_practicing': 'استمر في التدريب! 💪',
    'max_streak': 'أعلى سلسلة',
    "error": "خطأ في تحميل البلدان"
  },
};

//  lang state management
class LocaleNotifier extends Notifier<Locale> {
  static const String _boxName = 'app_box';
  static const String _localeKey = 'locale_key';
  @override
  Locale build() {
    _loadLocale();
    return const Locale('en'); // default
  }

 void toggleLocale()async {
      final newLocale = state == const Locale('en') ? const Locale('ar') : const Locale('en');
      state = newLocale;
      final box = await Hive.openBox(_boxName);
       await box.put(_localeKey , newLocale ==  Locale('en') ? 'en' : 'ar');

  }
  void _loadLocale()async {
    final box = await Hive.openBox(_boxName);
    final savedLocale = box.get(_localeKey, defaultValue: 'en');
    state = savedLocale == 'en' ? const Locale('en') : const Locale('ar');
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

// translation helper
final trProvider = Provider<String Function(String)>((ref) {
  final locale = ref.watch(localeProvider);
  return (String key) {
    return translations[locale.languageCode]?[key] ?? translations['en']?[key] ?? key;
  };
});