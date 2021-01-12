import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Utility {

  static List<Color> colorList = [
    Colors.red,
    Colors.pink,
    Colors.blue,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.pink,
    Colors.green,
    Colors.indigo,
    // Colors.lightGreenAccent,
    Colors.lightBlue,
    Colors.orange
  ];


  static Future<bool> isInternetConnected() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
