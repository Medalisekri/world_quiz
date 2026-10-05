import 'package:countries_api/models/country.dart';
import 'package:countries_api/providers/country.dart';
import 'package:countries_api/providers/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class QuizScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuizScreen();

}
class _QuizScreen extends ConsumerState<QuizScreen>{
  late final countryState = ref.read(countryProvider);
  late final countries = countryState.countries;
String? selectedAnswer;
void _showQuizTypeDialog(){
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Choose Quiz Type' , style: TextStyle(fontWeight: FontWeight.bold),),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ref.read(quizProvider.notifier).startQuiz(countries, 'flag');
            },
            child: Row(children: [
              Text('Flag Quiz' ),
              const SizedBox(width: 15,),
              Icon(Icons.flag)
            ],),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ref.read(quizProvider.notifier).startQuiz(countries, 'capital');
            },
            child: Row(children: [
              Text('Capital Quiz' ),
              const SizedBox(width: 15,),
              Icon(Icons.high_quality)
            ],),

          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ref.read(quizProvider.notifier).startQuiz(countries, 'population');
            },
            child:  Row(children: [
              Text('Population Quiz' ),
              const SizedBox(width: 15,),
              Icon(Icons.people)
            ],),

          ),
          SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                ref.read(quizProvider.notifier).startQuiz(countries, 'language');
              },
              child:  Row(children: [
                Text('Language Quiz' ),
                const SizedBox(width: 15,),
                Icon(Icons.language)
              ],)

          ),
        ],
      ));
}
  @override
  Widget build(BuildContext context) {
   final state = ref.watch(quizProvider);
      if(state.questions.isEmpty){
    return Scaffold(
      appBar: AppBar(
        title: Text('WorldQuiz'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child:
          ElevatedButton(
            onPressed: () {
              _showQuizTypeDialog();
            },
            child: Text('Start' , style: TextStyle(fontSize: 20),),
          ),
          )],
      ),
    );
   }
   if(state.currentIndex>=state.questions.length){
      return Scaffold(
          appBar: AppBar(
            title: Text('WorldQuiz'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
            centerTitle: true,
          ),
        body:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        Center(child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Score is : ', style: TextStyle(fontSize: 18, color: Colors.grey , fontWeight: FontWeight.bold)),
        Text(
          '${state.score}/${state.questions.length}',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
        ),

        ])),
          const SizedBox(height: 15,),
          ElevatedButton( onPressed: () {
            _showQuizTypeDialog(
            );

          }, child: Text('Another quiz?'))
        ]));
    }
   final currentQuestion = state.questions[state.currentIndex];
   return Scaffold(
     appBar: AppBar(
       title: Text('WorldQuiz'),
       backgroundColor: Colors.blue,
       foregroundColor: Colors.black,
       centerTitle: true,
     ),
    body: Column(children: [
      Expanded(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child:
            currentQuestion.question.startsWith('http')?
                Image.network(currentQuestion.question)
                :Text(currentQuestion.question ,style: TextStyle(
              fontWeight: FontWeight.bold , fontSize: 20
            ),)
                )])   ),
      for(String option in currentQuestion.options)
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child:
        TextButton(
            onPressed:  (){
      if(!state.answered) {
        setState(() => selectedAnswer = option);
        ref.read(quizProvider.notifier).answerQuestion(option);
      }
        }, style: TextButton.styleFrom(
          padding: EdgeInsets.all(20),

            foregroundColor: selectedAnswer==null?Colors.black :
            option ==currentQuestion.correctAnswer?Colors.green: option == selectedAnswer?Colors.red:Colors.black),
            child:Text(option ,style: TextStyle(
              fontSize: 15
            ),)
        )),
if(state.answered)
    ElevatedButton(onPressed: () {
      setState(()=>selectedAnswer =null
      );
      ref.read(quizProvider.notifier).nextQuestion();  },
      child: Text('Next' , style: TextStyle(fontSize: 15 ,fontWeight: FontWeight.bold),),),
        ],),
  );

  }
}