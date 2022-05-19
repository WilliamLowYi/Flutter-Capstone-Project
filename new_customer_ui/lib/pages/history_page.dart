import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/restaurant.dart';


class HistoryPage extends StatefulWidget {

  Order orderData;
  String orderId;
  HistoryPage(this.orderData, this.orderId, {Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: FirebaseDatabase.instance.reference().child('restaurant/${widget.orderData.restaurantId}').onValue,
      builder: (context, snapshot) {
        if (snapshot.data != null && (snapshot.data as Event).snapshot.value != null) {
          Restaurant restaurant = Restaurant.fromJson((snapshot.data as Event).snapshot.value);
          commentController.text = widget.orderData.comment;
          double totalPrice = 0;
          final foodsBoxWidget = <Widget>[];
          foodsBoxWidget.add(Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order History',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  widget.orderData.date,
                  style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ],
            ),
          ));
          widget.orderData.item.forEach((key, value) {
            restaurant.menu?.forEach((element) {
              if (element.id == key) {
                totalPrice += double.parse(element.price) * int.parse(value);
                foodsBoxWidget.add(Card(
                  child: ListTile(
                    leading: Image(
                        image: NetworkImage(element.image)
                    ),
                    title: Text(
                      element.name,
                      style: const TextStyle(
                          fontSize: 17.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity: $value',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Price: ${element.price}',
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '£ ${(double.parse(element.price) * int.parse(value)).toString()}',
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
              }
            });
          });
          foodsBoxWidget.add(
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                        fontSize: 17.0
                    ),
                  ),
                  Text(
                    '£ ${totalPrice.toString()}',
                    style: const TextStyle(
                        fontSize: 17.0
                    ),
                  )
                ],
              ),
            )
          );

          return Scaffold(
            appBar: AppBar(
                title: Text(restaurant.name)
            ),
            backgroundColor: Colors.grey[200],
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      child: Center(
                          child: Text(
                            'Order ID: ${widget.orderId}',
                            style: const TextStyle(
                              fontSize: 17.0
                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        color: Colors.white,
                        child: Column(
                          children: foodsBoxWidget,
                        )
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(7.0),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    'Comment',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              ),
                              StreamBuilder<Object>(
                                stream: FirebaseDatabase.instance.reference().child('order/${widget.orderId}/comment').onValue,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && (snapshot.data as Event).snapshot.value != null) {
                                      commentController.text = (snapshot.data as Event).snapshot.value;
                                  } else {
                                      commentController.text = '';
                                  }

                                  return TextField(
                                    maxLines: null,
                                    controller: commentController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Your Experience',
                                    ),
                                  );
                                }
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  HttpClient client = HttpClient();
                                  client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

                                  String url = 'www.twinword-sentiment-analysis.p.rapidapi.com/analyze/';

                                  final queryParameter = {
                                    'text': commentController.text,
                                  };

                                  HttpClientRequest request = await client.postUrl(Uri.https('www.twinword-sentiment-analysis.p.rapidapi.com', '/analyze/', queryParameter));

                                  request.headers.set('content-type', 'application/json');
                                  request.headers.set('x-rapidapi-host', 'twinword-sentiment-analysis.p.rapidapi.com');
                                  request.headers.set('x-rapidapi-key', 'f9c7ac6ec7msh5e3b423b0984d30p11a263jsnb29997964e57');

                                  request.add(utf8.encode(json.encode(queryParameter)));

                                  HttpClientResponse response = await request.close();

                                  String reply = await response.transform(utf8.decoder).join();

                                  var type = '';
                                  if (reply[11].toString() == 'g') {
                                    type = 'negative';
                                  } else {
                                    type = 'positive';
                                  }

                                  print(commentController.text + '--' + type);
                                  await FirebaseDatabase.instance.reference().child('order/${widget.orderId}').update({'comment': commentController.text});
                                  await FirebaseDatabase.instance.reference().child('order/${widget.orderId}').update({'rating': type});

                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Comment Updated Successful'),
                                  ));
                                },
                                child: const Text('Submit'),
                              )
                            ]
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}
