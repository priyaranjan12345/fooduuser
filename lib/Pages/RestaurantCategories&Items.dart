import 'package:flutter/material.dart';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controllers/CartController.dart';
import '../Controllers/DashboardController.dart';
import '../Controllers/RestaurantConrtoller.dart';
import '../Models/CartItem.dart';
import '../Models/Item.dart';

class RestaurantCategorieItems extends StatelessWidget {
  final RestaurantController restaurantController = Get.find();
  final DashboardController dashboardController = Get.find();
  final CartController cartController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Get.toNamed("/cart");
                },
                icon: Obx(() => Badge(
                      badgeContent:
                          Text(cartController.cartitemcount.value.toString()),
                      badgeColor: Colors.orange,
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.amber,
                      ),
                    ))),
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 10),
                          child: Text(restaurantController.restaurantname,
                              style: GoogleFonts.farro(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              )),
                        ),
                      ),
                      restaurantController.restaurantphoto.isBlank
                          ? Container(
                              height: 150,
                              width: Get.context.width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/noimage.png"))),
                            )
                          : Container(
                              height: 150,
                              width: Get.context.width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(restaurantController
                                          .restaurantphoto))),
                            ),
                    ],
                  ),
                )),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 220),
                  child: categoryList(),
                )),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> categoryList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantController.currentrestaurantid)
          .collection('categories')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text("No data found"),
          );
        }

        if (snapshot.hasData) {
          var categoriesdocs = snapshot.data.docs;
          print(categoriesdocs.length);
          if (categoriesdocs.length != 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categoriesdocs.length,
                itemBuilder: (context, index) {
                  String categoriesname = categoriesdocs[index].get('cat_name');
                  String catphoto = categoriesdocs[index].get('cat_photo');
                  String catid = categoriesdocs[index].id;
                  //  print(categoriesname);
                  //doesnt exist

                  return Align(
                      alignment: Alignment.topCenter,
                      child: ExpansionTile(
                        //childrenPadding: EdgeInsets.all(10),
                        initiallyExpanded: false,
                        //backgroundColor: Colors.amber[50],

                        collapsedBackgroundColor: Colors.white60,
                        tilePadding: EdgeInsets.all(15),
                        title: Text(
                          categoriesname,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        leading: catphoto.isBlank
                            ? Container(
                                height: Get.context.height * 0.4,
                                width: Get.context.width * 0.3,
                                child: Image.asset("assets/noimage.png"),
                              )
                            : Container(
                                height: Get.context.height * 0.4,
                                width: Get.context.width * 0.3,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(catphoto))),
                              ),
                        children: [
                          itemsList(catid),
                        ],
                      ));
                },
              ),
            );
          } else {
            return Center(child: Text("No Categories found from Restaurant"));
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> itemsList(String catid) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantController.currentrestaurantid)
            .collection('categories')
            .doc(catid)
            .collection("items")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.docs.length);
            if (snapshot.data.docs.length != 0) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('restaurants')
                      .doc(restaurantController.currentrestaurantid)
                      .collection('categories')
                      .doc(catid)
                      .collection("items")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("No Items found yet");
                    }
                    if (snapshot.hasError) {
                      return Text("Error in data");
                    }
                    if (snapshot.hasData) {
                      var itemdocs = snapshot.data.docs;
                      if (itemdocs.length != 0) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemdocs.length,
                          itemBuilder: (context, index) {
                            var itemname = itemdocs[index].get('name');
                            var price = itemdocs[index].get('totalprice');
                            var description =
                                itemdocs[index].get('description');
                            var itemtype = itemdocs[index].get('type');
                            var itemid = itemdocs[index].id;

                            //   print(itemname);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildItem(
                                  itemtype,
                                  itemname,
                                  description,
                                  price.toString(),
                                  itemid,
                                  catid,
                                  restaurantController.currentrestaurantid),
                            );
                          },
                        );
                      } else {
                        return Text("No items added yet");
                      }
                    }
                    return Text("items found");
                  });
            } else
              return Text("Items not added yet");
          }
          if (!snapshot.hasData) {
            return Text("No items found");
          }
          if (snapshot.hasError) {
            return Text("Getting data failed");
          }
          return Text("data");
        });
  }

  ListTile buildItem(String itemtype, String itemname, String description,
      String price, String itemid, String catid, String restid) {
    return ListTile(
        tileColor: itemtype == "Veg"
            ? Colors.greenAccent[700].withOpacity(0.5)
            : Colors.red.withOpacity(0.3),
        enableFeedback: true,
        selectedTileColor: Colors.white,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  itemname,
                  style: GoogleFonts.nunito(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  description,
                  style: GoogleFonts.nunito(fontSize: 15),
                ))
          ],
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "₹$price",
            style: GoogleFonts.workSans(fontSize: 25),
          ),
        ),
        trailing: ElevatedButton(
          child: Text("Add to Cart"),
          onPressed: () {
            // print("Item id :$itemid, Cat id:$catid , Rest id:$restid");
            var item = Item(
                catid: catid,
                itemid: itemid,
                restid: restid,
                name: itemname,
                description: description,
                price: double.parse(price),
                type: itemtype,
                restname: restaurantController.restaurantname);
            var cartitem =
                CartItem(item: item, quantity: 1, subtotal: item.price);
            cartController.addToCart(cartitem);
          },
        ));
  }
}
