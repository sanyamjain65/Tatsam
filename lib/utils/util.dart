import 'dart:io';

import 'package:connectivity/connectivity.dart';


class Utility {


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
