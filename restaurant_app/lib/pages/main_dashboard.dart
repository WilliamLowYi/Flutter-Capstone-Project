import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/myLibrary/database_access_object.dart';
import 'package:restaurant_app/myLibrary/methods.dart';
import 'package:restaurant_app/myLibrary/order.dart';
import 'package:restaurant_app/pages/sentiment_analysis.dart';

class MainPage extends StatefulWidget {
  var email;
  MainPage(String givenEmail, {Key? key}){
    super.key;
    email = givenEmail;
  }
  @override
  _MainPageState createState() => _MainPageState(email);
}

class _MainPageState extends State<MainPage> {

  // Which restaurant this account belong to
  String restaurantName = '';
  String restaurantID = '';
  late final orders;
  late final email;
  final DatabaseReference _database = DatabaseAccess().getDatabaseReference();

  _MainPageState(String givenEmail){
    email = givenEmail;
  }


  getRestaurantDetails(String email) async{
    if (email.contains('.')) {
      email = email.replaceAll('.', '-');
    }
    print(email);
    String userPath = 'user/$email';
    if (restaurantName.isEmpty){
      await _database.child(userPath + '/restaurant_name').once().then((snapshot) {
        setState(() {
          restaurantName = snapshot.value;
          print(restaurantName);
        });
      });
    }
    if (restaurantID.isEmpty) {
      await _database.child(userPath + '/restaurant_id').once().then((snapshot) {
        setState(() {
          restaurantID = snapshot.value;
          print(restaurantID);
        });
      });
    }
    if (restaurantName.isNotEmpty && restaurantID.isNotEmpty){
      openOrder();
      print('if');
    }
  }

  openOrder() {
    _database.child('open_order/$restaurantID').once().then((snapshot) {
      print(snapshot.value);
      final data = snapshot.value as Map<dynamic, dynamic>;
      print(data);
      data.forEach((key, value) {
        print(key);
        print(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if(restaurantID.isEmpty || restaurantName.isEmpty){
      getRestaurantDetails(email);
      print('while');
    }
  }

  // Pass in each order
  Padding buildOrder(String orderKey, dynamic data)  {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
      child: Card(
        color: Colors.white10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Column(
            children: foodList(orderKey, data['item'], data['service mode'], data['customer id']),
          ),
        )
      ),
    );
  }

  foodList(String orderKey, Map<dynamic, dynamic> item, String serviceMode, String email){
    var list = <Widget>[];
    item.forEach((key, value) async {
      list.add(
        StreamBuilder(
          stream: _database.child('restaurant/$restaurantID/menu/$key').onValue,
          builder: (context, snapshot) {
            String name = "", image = '';
            if ((snapshot.data! as Event).snapshot.value != null){
              name = (snapshot.data! as Event).snapshot.value['name'];
              image = (snapshot.data! as Event).snapshot.value['image'];
            }
            return ListTile(
              leading: Image(
                image: NetworkImage(image),
                height: 300,

              ),
              title: Methods.customText(name, size: 20.0),
              subtitle: Column(
                children: [
                  Row(
                      children: [
                        Methods.customText('Quantity: $value', size: 17.0),
                      ]
                  ),
                ],
              ),
            );
          },
        ),
      );

    });
    list.add(Text(
      'Service Mode: ${Methods.capitalize(serviceMode)}',
      style: const TextStyle(
        fontSize: 16.0,
      ),
    ),);
    list.add(StreamBuilder(
        stream: _database.child('user/$email').onValue,
        builder: (context, snapshot) {
          String name = 'Error';
          if ((snapshot.data! as Event).snapshot.value != null) {
            name = (snapshot.data! as Event).snapshot.value['name'];
          }
          return Text(
            'Customer: $name',
            style: const TextStyle(
              fontSize: 16.0,
            ),
          );
        }
    ));
    list.add(ElevatedButton(
      child: const Text(
        'Done',
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
      onPressed: () {
        _database.child('order/$orderKey/status').set('complete');
      },
    ));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${restaurantName[0].toUpperCase()}${restaurantName.substring(1)}\'s Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SentimentAnalysis(restaurantID)));
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: StreamBuilder(
              stream: _database.child('order').onValue,
              builder: (context, snapshot) {
                final containersList = <Widget>[];
                if (snapshot.data != null) {
                  final allOrder = Map<dynamic, dynamic>.from((snapshot.data! as Event).snapshot.value);
                  allOrder.forEach((key, value) {
                    final order = Map<dynamic, dynamic>.from(value);
                    if (order['restaurant id'] == restaurantID && order['status'] == 'in progress'){
                      containersList.add(buildOrder(key, order));
                    }
                  });
                }
                return Column(
                   children: containersList,
                );
              }
            )
            ),
          ),
      ),
    );
  }
}
