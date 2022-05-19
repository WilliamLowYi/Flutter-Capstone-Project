import 'package:firebase_auth/firebase_auth.dart';

class CustomerUser {
  User? _user;
  CustomerUser(this._user);

  bool isUserLoggedIn() {
    return (_user != null ? false : true);
  }

  String getUserEmail() {
    return _user?.email ?? 'jinglow0787@gmail-com';
  }
}