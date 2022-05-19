

import 'package:firebase_database/firebase_database.dart';

class User {
  late final String name;
  late final String type;
  late final int phoneNumber;

  User(this.name, this.phoneNumber, this.type);

  User.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        phoneNumber = json['text'] as int,
        type = json['type'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'name': name,
    'phone': phoneNumber,
    'type': type,
  };
}
