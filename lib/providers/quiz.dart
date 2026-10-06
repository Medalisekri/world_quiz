import 'dart:async';
import 'package:countries_api/core/utils/quiz_helper.dart';
import 'package:countries_api/models/country.dart';
import 'package:countries_api/models/quiz_questions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/cache.dart';

class QuizState {
  final List<QuizQuestions> questions;
  final int currentIndex;
  final int score;
  final int streak;
  final int maxStreak;
  final bool answered;
  final double timeLeft;
  final bool isFinished;
  final String difficulty;
  final String continent;
  final String? selectedAnswer;

  QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.streak = 0,
    this.maxStreak = 0,
    this.answered = false,
    this.timeLeft = 12.0,
    this.isFinished = false,
    this.difficulty = 'easy',
    this.continent = 'All',
    this.selectedAnswer,
  });

  QuizState copyWith({
    List<QuizQuestions>? questions,
    int? currentIndex,
    int? score,
    int? streak,
    int? maxStreak,
    bool? answered,
    double? timeLeft,
    bool? isFinished,
    String? difficulty,
    String? continent,
    String? selectedAnswer,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      maxStreak: maxStreak ?? this.maxStreak,
      answered: answered ?? this.answered,
      timeLeft: timeLeft ?? this.timeLeft,
      isFinished: isFinished ?? this.isFinished,
      difficulty: difficulty ?? this.difficulty,
      continent: continent ?? this.continent,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    );
  }
}

class QuizProvider extends StateNotifier<QuizState> {
  QuizProvider() : super(QuizState());

  Timer? _timer;
  final _cache = CacheRepository();

  void startQuiz(List<Country> countries, String difficulty, String continent) {
    state = QuizState();
    _timer?.cancel();
    final questions = generateQuestions(countries, difficulty, continent);
    state = QuizState(
      questions: questions,
      difficulty: difficulty,
      continent: continent,
    );
    _startTimer();
  }

  void answerQuestion(String? answer) {
    if (state.answered) return;
    _timer?.cancel();

    final currentQuestion = state.questions[state.currentIndex];
    final isCorrect = answer == currentQuestion.correctAnswer;

    int newStreak = isCorrect ? state.streak + 1 : 0;
    int newMaxStreak = newStreak > state.maxStreak ? newStreak : state.maxStreak;

    state = state.copyWith(
      answered: true,
      score: isCorrect ? state.score + 1 : state.score,
      streak: newStreak,
      maxStreak: newMaxStreak,
      selectedAnswer: answer,
    );
  }

  void nextQuestion() {
    if (state.currentIndex + 1 >= state.questions.length) {
      _finishQuiz();
      return;
    }

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      answered: false,
      timeLeft: 12.0,
      selectedAnswer: null,
    );
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (state.timeLeft > 0.1 && !state.answered) {
        state = state.copyWith(timeLeft: state.timeLeft - 0.1);
      } else if (state.timeLeft <= 0.1 && !state.answered) {

        answerQuestion(null);
      }
    });
  }

  Future<void> _finishQuiz() async {
    _timer?.cancel();
    await _cache.saveQuizResult({
      'date': DateTime.now().toIso8601String(),
      'score': state.score,
      'total': state.questions.length,
      'difficulty': state.difficulty,
      'continent': state.continent,
      'maxStreak': state.maxStreak,
    });
    state = state.copyWith(isFinished: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final quizProvider = StateNotifierProvider<QuizProvider, QuizState>(
      (ref) => QuizProvider(),
);