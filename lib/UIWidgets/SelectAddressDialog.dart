import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Controllers/UserProfileController.dart';
import '../Services/UserDBService.dart';
import 'AddAddressDialog.dart';

class SelectAddressDialog extends StatelessWidget {
  final UserProfileController userProfileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: Get.context.height * 0.3,
        width: Get.context.width * 0.8,
        child: Container(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_location,
                        color: Colors.blue,
                        size: 40,
                      ),
                      onPressed: () async {
                        Get.defaultDialog(
                            title: "", content: AddAddressDialog());
                      },
                    ),
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error ${snapshot.error}");
                      }
                      if (!snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        return Text("No data");
                      }
                      if (snapshot.hasData) {
                        var doc = snapshot.data;
                        try {
                          var addressfield = doc.get("userinfo.addresses");
                          List<String> addresses =
                              new List<String>.from(addressfield);
                          if (addresses.length == 0) {
                            userProfileController.usercurrentaddress.value = "";
                            return Text("No address added yet");
                          } else {
                            var selectedindex = 0.obs;
                            return ListView.builder(
                              itemCount: addresses.length,
                              itemBuilder: (context, index) {
                                var tileselected = false.obs;
                                return Obx(() => ListTile(
                                      onTap: () {
                                        tileselected.value = true;
                                        selectedindex.value = index;
                                        userProfileController.usercurrentaddress
                                            .value = addresses[index];
                                      },
                                      tileColor: selectedindex.value == index
                                          ? Colors.amberAccent
                                          : Colors.white24,
                                      title: Text(addresses[index]),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () async {
                                          await UserDBService()
                                              .deletAAddress(addresses[index]);

                                          userProfileController
                                              .usercurrentaddress.value = "";
                                        },
                                      ),
                                    ));
                              },
                            );
                          }
                        } on StateError catch (e) {
                          print("address field not exist $e");
                          // userProfileController.usercurrentaddress.value = "";
                          return Center(child: Text("No address field found"));
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
