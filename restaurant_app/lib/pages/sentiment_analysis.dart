import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/myLibrary/database_access_object.dart';
import 'package:pie_chart/pie_chart.dart';

class SentimentAnalysis extends StatefulWidget {

  String restaurantId;
  SentimentAnalysis(this.restaurantId, {Key? key}) : super(key: key);

  @override
  State<SentimentAnalysis> createState() => _SentimentAnalysisState(restaurantId);
}

class _SentimentAnalysisState extends State<SentimentAnalysis> {

  String restaurantId;
  _SentimentAnalysisState(this.restaurantId);

  final DatabaseReference _database = DatabaseAccess().getDatabaseReference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentiment Analysis'),
      ),
      backgroundColor: Color(0xFFFDF4F4),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: StreamBuilder(
            stream: _database.child('order').onValue,
            builder: (context, snapshot) {
              final children = <Widget>[];
              final orders = Map<dynamic, dynamic>.from((snapshot.data as Event).snapshot.value);

              Map<String, double> dataMap = {
                'Positive': 0,
                'Negative': 0,
              };

              orders.forEach((key, value) {
                value = Map<dynamic, dynamic>.from(value);
                if (value['restaurant id'] == restaurantId && value['rating'].toString().isNotEmpty) {
                  // Card for Customer Review
                  Color textColour = Colors.red;
                  if (value['rating'].toString() == 'positive'){
                    textColour = Colors.green;
                    dataMap.update('Positive', (value) => value + 1);
                  } else {
                    dataMap.update('Negative', (value) => value + 1);
                  }
                  children.add(
                    Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value['rating'].toString()[0].toUpperCase() + value['rating'].toString().substring(1),
                            style: TextStyle(
                              color: textColour,
                              fontSize: 16.0,
                            )
                          ),
                        ),
                        subtitle: Text(
                          value['comment'].toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      elevation: 8.0,
                      shadowColor: Colors.grey,
                      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white)
                      ),
                    )
                  );
                }
              });
              // For empty reviews
              if (children.isEmpty){
                children.add(
                  Card(
                    child: const Center(
                      child: Text(
                        'There are no review right now. Come back later.'
                      )
                    ),
                    elevation: 8.0,
                    shadowColor: Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white)
                    ),
                  )
                );
              }

              children.insert(0,
                SizedBox(
                  child: PieChart(
                    dataMap: dataMap,
                    colorList: [
                      Colors.green[300] as Color,
                      Colors.red[300] as Color,
                    ],
                  ),
                  height: 175,
                )
              );
              return Column(
                children: children,
              );
            },
          )
        ),
      ),
    );
  }
}
