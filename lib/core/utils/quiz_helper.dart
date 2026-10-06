import 'dart:math';
import 'package:countries_api/models/country.dart';
import 'package:countries_api/models/quiz_questions.dart';

List<QuizQuestions> generateQuestions(
    List<Country> countries,
    String difficulty,
    String continent
    ) {

  List<Country> filteredCountries = continent == 'All'
      ? countries
      : countries.where((c) => c.continent == continent).toList();

  if (filteredCountries.length < 4) {
    filteredCountries = countries;
  }

  String questionType;
  switch (difficulty) {
    case 'easy':
      questionType = 'flag';
      break;
    case 'medium':
      questionType = 'capital';
      break;
    case 'hard':

      questionType = Random().nextBool() ? 'population' : 'language';
      break;
    default:
      questionType = 'flag';
  }

  final List<QuizQuestions> questions = [];
  filteredCountries.shuffle();

  final selected = filteredCountries.take(10).toList();

  for (final correct in selected) {

    final other = filteredCountries.where((c) => c.name != correct.name).toList();
    other.shuffle();
    final wrongOptions = other.take(3).toList();

    final options = [correct.name, ...wrongOptions.map((c) => c.name)]..shuffle();

    final questionText = switch (questionType) {
      'flag' => correct.flagUrl,
      'capital' => correct.capital,
      'population' => correct.population.toString(),
      'language' => correct.languages.isNotEmpty ? correct.languages[0] : 'Unknown',
      _ => correct.flagUrl,
    };

    questions.add(QuizQuestions(
      question: questionText,
      options: options,
      correctAnswer: correct.name,
    ));
  }

  return questions;
}