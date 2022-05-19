import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:new_customer_ui/pages/home/home.dart';
import 'package:new_customer_ui/routes/route_assistant.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51K3Ne6GHJ32rGcYAPEGZzzEK8UwwoZXw6sovWeuJEY2NrSEknu853o5l6rixgZaFnriD0bQ8zQuwiXGKQMM6vp3v00kvGbm4CK';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase. initializeApp(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          print('Error on Firebase Initialization. ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Yi\'s Customer App',
            home: Home(),
            initialRoute: RouteAssistant.initial,
            getPages: RouteAssistant.pagesRoute,
          );
        }
      },
    );
  }
}

