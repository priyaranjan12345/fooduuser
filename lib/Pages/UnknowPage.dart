import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UnknownPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Unknown Route ${Get.previousRoute}"),
        ),
      ),
    );
  }
}
