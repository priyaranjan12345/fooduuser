import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../Controllers/HomeController.dart';
import '../../UIWidgets/LocationProvideWidget.dart';
import '../../UIWidgets/RestaurantLists.dart';

class DashboardHome extends StatelessWidget {
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.context.width,
      height: Get.context.height,
      decoration: BoxDecoration(color: Colors.white12),
      child: Padding(
        padding:
            EdgeInsets.only(top: Get.context.height * 0.03, left: 5, right: 10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () async {
                              //  var position = await getPosition();
                              // await homeController.setLocationData(position);
                              await Get.bottomSheet(
                                LocationProviderWidget(),
                                ignoreSafeArea: true,
                                elevation: 9,
                                isDismissible: true,
                                enableDrag: true,
                              );
                            },
                            icon: Icon(
                              Icons.location_on_outlined,
                              color: Colors.yellow,
                              size: 35,
                            ),
                          ),
                        ),
                        Obx(() => Expanded(
                              flex: 4,
                              child: Text(
                                homeController.address.value.isBlank
                                    ? "No location selected yet"
                                    : homeController.address.value,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.cyan),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Get.context.height * 0.01, left: 15),
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                String name =
                                    snapshot.data.get('userinfo.name');

                                // print(name);
                                return Text(
                                  "Hey, " + name.split(" ").first,
                                  style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                );
                              }
                              return Text(
                                "Hey User",
                                style: GoogleFonts.roboto(
                                    fontSize: 26, fontWeight: FontWeight.w600),
                              );
                            }),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: Get.context.height * 0.18),
                  child: RestaurantLists(homeController: homeController),
                )),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: Get.context.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 10, top: Get.context.height * 0.06),
                          child: buildFloatingSearchBar(),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    return FloatingSearchBar(
      backdropColor: Colors.transparent,
      hint: 'Search ',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 0),
      transitionDuration: const Duration(milliseconds: 200),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: 0.0,
      openAxisAlignment: 0.0,
      width: Get.context.width,
      debounceDelay: const Duration(milliseconds: 00),
      closeOnBackdropTap: true,
      hintStyle: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.back(
          color: Colors.red,
          showIfClosed: false,
        ),
        FloatingSearchBarAction(
          child: IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.amber,
            ),
            onPressed: () {
              Get.defaultDialog();
            },
          ),
        )
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            //color: Colors.amber.shade100,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: Colors.accents.map((color) {
                return Container(
                  height: 80,
                  color: color,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
