import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/myLibrary/user.dart';

class DatabaseAccess{

  late DatabaseReference _databaseReference;

  DatabaseAccess(){
    _databaseReference = FirebaseDatabase.instance.reference();
  }

  void saveUser(User user) {
    _databaseReference.push().set(user.toJson());
  }

  Query getUser() {
    return _databaseReference.child('user/');
  }

  DatabaseReference getDatabaseReference() {
    return _databaseReference;
  }

  bool isEmailHasRestaurantType(String email) {
    if (email.contains('.')) {
      email = email.replaceAll('.', '-');
    }
    String userPath = 'user/$email';
    _databaseReference.child(userPath).once().then((snapshot) {
      final String accountType = snapshot.value;
      if (accountType == 'restaurant') {
        // Todo: ABLE to return true
        return true;
      }
      return false;
    });
    return false;
  }

}