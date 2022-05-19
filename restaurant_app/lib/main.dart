import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/pages/login.dart';
// https://stackoverflow.com/questions/68806876/firebase-realtime-database-connection-killed-different-region
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(RestaurantMain());
}

class RestaurantMain extends StatelessWidget {

  // Future is part of the widget so it should not be call directly inside build
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // https://firebase.flutter.dev/docs/overview/#initializing-flutterfire
    return FutureBuilder(
        // Initialize FlutterFire
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print("Something went wrong.");
          }

          // Waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show application if accessible
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Login with email & password",
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: LoginPage(),
          );
        }
    );

  }
  
}