
import 'package:countries_api/core/utils/quiz_helper.dart';
import 'package:countries_api/models/country.dart';
import 'package:countries_api/models/quiz_questions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class QuizState {
  final List<QuizQuestions> questions;
   final int currentIndex;
  final int score;
  final bool answered;
  QuizState({
    this.questions = const[],
    this.currentIndex = 0,
    this.score = 0,
    this.answered = false,
});
  QuizState copyWith({
    List<QuizQuestions>? questions,
    int? currentIndex,
    int? score,
    bool? answered,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      answered: answered ?? this.answered,
    );
  }
}

class QuizProvider extends StateNotifier<QuizState> {
  QuizProvider(): super(QuizState());
  QuizState startQuiz(List<Country> countries , String type){
    final questions = generateQuestions(countries, type);
    return state = QuizState(questions: questions);
  }
  void answerQuestion(String answer) {
    state = state.copyWith(answered: true , score: answer ==  state.questions[state.currentIndex].correctAnswer? state.score+1 : state.score);
  }
  void nextQuestion(){
    state = state.copyWith(score: state.currentIndex+1 , answered: false);
  }
}final quizProvider = StateNotifierProvider<QuizProvider , QuizState>(
        (ref)=> QuizProvider()
);