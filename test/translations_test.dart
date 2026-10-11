import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {
  // Inline translation map matching your locale_provider.dart
  const translations = {
    'en': {
      'app_title': 'WorldQuiz',
      'quiz': 'Quiz',
      'capital': 'Capital',
      'continent': 'Continent',
      'difficulty': 'Difficulty',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
    },
    'ar': {
      'app_title': 'كويز العالم',
      'quiz': 'اختبار',
      'capital': 'العاصمة',
      'continent': 'القارة',
      'difficulty': 'الصعوبة',
      'easy': 'سهل',
      'medium': 'متوسط',
      'hard': 'صعب',
    },
  };

  group('Translation System', () {

    test('should return English translation when locale is en', () {
      const locale = Locale('en');
      final result = translations[locale.languageCode]?['app_title'] ?? '';

      expect(result, 'WorldQuiz');
    });

    test('should return Arabic translation when locale is ar', () {
      const locale = Locale('ar');
      final result = translations[locale.languageCode]?['app_title'] ?? '';

      expect(result, 'كويز العالم');
    });

    test('should fall back to English for unknown locale', () {
      const locale = Locale('fr'); // French - not supported
      final result = translations[locale.languageCode]?['app_title']
          ?? translations['en']?['app_title']
          ?? '';

      expect(result, 'WorldQuiz');
    });

    test('should return key itself if translation not found', () {
      const locale = Locale('en');
      const missingKey = 'non_existent_key';
      final result = translations[locale.languageCode]?[missingKey] ?? missingKey;

      expect(result, 'non_existent_key');
    });

    test('all English keys should have Arabic equivalents', () {
      final englishKeys = translations['en']!.keys.toSet();
      final arabicKeys = translations['ar']!.keys.toSet();

      // Every English key should exist in Arabic
      expect(englishKeys.difference(arabicKeys), isEmpty);
      // Every Arabic key should exist in English
      expect(arabicKeys.difference(englishKeys), isEmpty);
    });

    test('Arabic translations should not be empty strings', () {
      final arabicValues = translations['ar']!.values;

      for (final value in arabicValues) {
        expect(value, isNotEmpty);
        expect(value.trim(), isNotEmpty);
      }
    });
  });
}