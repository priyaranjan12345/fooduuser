import 'package:flutter/material.dart';

import 'package:flare_loading/flare_loading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controllers/DashboardController.dart';

class OrderSuccessfullPage extends StatelessWidget {
  final String orderid;
  OrderSuccessfullPage({this.orderid});
  final DashboardController dashboardController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green[600],
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: Get.context.height * 0.1),
                child: FlareLoading(
                  name: 'assets/animations/ordersuccess.flr',
                  startAnimation: 'open and close',
                  loopAnimation: 'open and close',

                  // endAnimation: ,
                  isLoading: true,

                  alignment: Alignment.topCenter,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  until: () => Future.delayed(Duration(seconds: 5)),
                  onSuccess: (_) {
                    print('Finished');
                  },
                  onError: (err, stack) {
                    print(err);
                  },
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Thank You Ordering with Us.",
                      style: GoogleFonts.pacifico(
                          color: Colors.white, fontSize: 30, letterSpacing: 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Order placed successfully with Order ID: $orderid",
                        style: GoogleFonts.asap(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.indigo),
                        onPressed: () {
                          dashboardController.currentindex.value = 2;
                          Get.offAllNamed("/dashboard");
                        },
                        child: Text("Go to Orders"))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
