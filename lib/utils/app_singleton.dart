import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppSingleton {
  AppSingleton._privateConstructor();

  static final AppSingleton instance = AppSingleton._privateConstructor();

  showMessage(String message) {
    if (message.isNotEmpty) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


}
