import 'package:countries_api/models/country.dart';
import 'package:flutter/material.dart';
class CountryDetailScreen extends StatelessWidget {
  final Country? country;
  const CountryDetailScreen({super.key, this.country});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WorldQuiz'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        body:
            SingleChildScrollView(child:
            Center(child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        country!.flagUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Icon(Icons.flag, size: 80),
                      ),
                  const SizedBox(height: 15,),
                  Text('Country Detail' ,
                      style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold , )),
                const SizedBox(height: 15,),
                Text(country!.name ,
                  style: TextStyle(fontSize: 16 ,fontWeight: FontWeight.bold),),
                     Container(
                 padding: EdgeInsets.all(40),
                 margin: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   border: Border.all(color:Colors.blue.withValues(alpha: 0.7)),
                     borderRadius: BorderRadius.circular(20),
                     gradient: LinearGradient(
                         begin : Alignment.topLeft,
                         end: Alignment.bottomRight,
                         colors: [Colors.white54 , Colors.blueAccent.withValues(alpha: 0.4)
                           , Colors.white12.withValues(alpha: 0.4)] )
                        ),
                         child:
                           Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                          children: [
                              Text( 'Capital: ${country?.capital}' ,
                                style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 20),),
                              const SizedBox(height: 10),
                              Text('Continent: ${country?.continent}',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              const SizedBox(height: 10),
                              Text('Languages: ${country?.languages.join(', ')}',softWrap: true,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              const SizedBox(height: 10),
                              Text('Currencies: ${country?.currencies.join(', ')}',softWrap: true,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              const SizedBox(height: 10),
                              Text('Population: ${country?.population}',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        ]) )
             ])))) ;
  }
}




