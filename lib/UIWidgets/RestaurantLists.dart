import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controllers/DashboardController.dart';
import '../Controllers/HomeController.dart';
import '../Controllers/RestaurantConrtoller.dart';
import '../Pages/RestaurantCategories&Items.dart';

class RestaurantLists extends StatelessWidget {
  RestaurantLists({
    Key key,
    @required this.homeController,
  }) : super(key: key);

  final HomeController homeController;
  final RestaurantController restaurantController = Get.find();
  final DashboardController dashboardController = Get.find();
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.9,
      child: Obx(() => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("restaurants")
                .where('userinfo.deliverablepins',
                    arrayContains: homeController.postalcode.value)
                .snapshots(),
            builder: (context, snapshot) {
              print(homeController.postalcode);
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text("Loading"),
                  ],
                ));
              }

              if (snapshot.hasData) {
                var restaurantdocs = snapshot.data.docs;
                print(restaurantdocs.length);
                if (restaurantdocs.length == 0) {
                  return Center(
                      child: Text("No Restaurant near your location"));
                } else {
                  return Container(
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: Get.context.height * 0.01, left: 15),
                          child: Text(
                            "${restaurantdocs.length} restaurants found",
                            style: GoogleFonts.titilliumWeb(
                                fontWeight: FontWeight.w400, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: Get.context.height * 0.025),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: restaurantdocs.length,
                            itemBuilder: (context, index) {
                              var restdoc = restaurantdocs[index];
                              var restaurantid = restdoc.get('userinfo.uid');
                              String restaurantphoto =
                                  restdoc.get('userinfo.restphotourl');
                              var restaddress = restdoc.get('userinfo.address');
                              var restname =
                                  restdoc.get('userinfo.restaurant_name');
                              return buildRestaurantCard(restaurantphoto,
                                  restname, restaddress, restaurantid);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              return Text("No data");
            },
          )),
    );
  }

  Widget buildRestaurantCard(
      String restaurantphoto, restname, restaddress, restaurantid) {
    return InkWell(
      onTap: () {
        restaurantController.currentrestaurantid = restaurantid;
        restaurantController.restaurantname = restname;
        restaurantController.restaurantphoto = restaurantphoto;
        Get.to(() => RestaurantCategorieItems());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40), color: Colors.white),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white,
            elevation: 9,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: restaurantphoto.isBlank
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("assets/noimage.png"),
                            )))
                        : Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(restaurantphoto))),
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      restname,
                      style: GoogleFonts.koHo(
                          color: Colors.indigo,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      restaddress,
                      style: GoogleFonts.lato(
                          color: Colors.indigo,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
