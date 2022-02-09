import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

// ignore: missing_return
Stream<void> checkconnection() {
  var dialogshown = false;
  // ignore: cancel_subscriptions
  StreamSubscription<ConnectivityResult> subscription =
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.mobile) {
      print("Currently on Mobile");
      if (dialogshown) {
        Get.back();
        dialogshown = false;
      }
    } else if (result == ConnectivityResult.wifi) {
      print("Currently on wifi");
      if (dialogshown) {
        Get.back();
        dialogshown = false;
      }
    } else {
      dialogshown = true;
      AwesomeDialog(
          context: Get.context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'No Internet',
          desc: 'Please turn on your internet connection....',
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false)
        ..show();
      print("no internet");
    }
  });
  subscription.onError((e) => print("error $e"));
}
