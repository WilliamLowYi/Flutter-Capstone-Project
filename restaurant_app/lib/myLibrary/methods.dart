import 'package:flutter/material.dart';


class Methods {

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar(
      String text, Color? color, BuildContext buildContext) {
    return ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 18.0),),
      backgroundColor: color,
    ));
  }

  static String capitalize(String text){
    List<String> list = text.split(' ');
    for (int i = 0; i < list.length; i++) {
      list[i] = '${list[i][0].toUpperCase()}${list[i].substring(1)}';
    }
    return list.join(' ');
  }

  static Text customText(String text, {double size=14.0}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
      ),
    );
  }
}