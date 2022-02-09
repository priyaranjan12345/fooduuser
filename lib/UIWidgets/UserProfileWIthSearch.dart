import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../Controllers/UserProfileController.dart';

class UserProfileWithSearch extends StatelessWidget {
  final UserProfileController userprofile = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          color: Colors.yellow.shade700,
          border: Border.all(width: 2, color: Colors.yellow.shade800),
          borderRadius: BorderRadius.circular(200)),
      child: Obx(() => CircleAvatar(
            // radius: 30,
            backgroundImage: userprofile.imageurl.value.isBlank
                ? NetworkImage(
                    "http://www.venmond.com/demo/vendroid/img/avatar/big.jpg")
                : NetworkImage(userprofile.imageurl.value),
          )),
    );
  }
}
