import 'package:countries_api/providers/country.dart';
import 'package:countries_api/providers/quiz.dart';
import 'package:countries_api/screens/country_detail.dart';
import 'package:countries_api/screens/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountryScreen();
}
class _CountryScreen extends ConsumerState<CountryScreen>{
  var selectedContinent ='All';
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(countryProvider);
    final continents= ['All',...state.countries.map((c)=>c.continent).toSet()];
    final filtered  = selectedContinent=='All'?state.countries : state.countries.where((c)=>c.continent == selectedContinent).toList();
  if(state.errorMessage!=null){
      return Scaffold(
        appBar: AppBar(

            title: Text('WorldQuiz'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),

        body:SafeArea(
            child: Center(child: Text(state.errorMessage! ,
              style: TextStyle(color: Colors.red ,fontSize: 25), )
      )));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('WorldQuiz'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body:
    SafeArea(child:
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
        ),
        child:Column(children: [
          Container(
            padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.7),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15)
              ),
              child:
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
              Row(
                spacing: 20,
            children: [
              for(String cou in continents)
                GestureDetector(
                  onTap: (){
                    setState(() =>selectedContinent =cou
                    );
                  },
                  child: Text(cou , style:TextStyle(color:selectedContinent ==cou? Colors.white : Colors.black)),
                )
            ],
          ))) ,
        Expanded(
    child:
        ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context , index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CountryDetailScreen(country:filtered[index])));
                },
                  child:
             Card(
                color: Colors.blue.withValues(alpha: 0.6),
                  shadowColor: Colors.black.withValues(alpha: 0.8),
                  elevation: 10,
                 margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child:
               ListTile(
                leading:
                Image.network(
                  filtered[index].flagUrl,
                  width: 75,
                  height: 75,
                  errorBuilder: (context, error, stack) =>
                      Icon(Icons.flag, size: 40),
                ),
                title: Text(filtered[index].name),
              )));
            }),
        )])),
    ),

    floatingActionButton: FloatingActionButton.extended(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>QuizScreen()));
 } ,  label: Text('Quiz'),
      icon: Icon(Icons.quiz),),
    );
  }
  }
