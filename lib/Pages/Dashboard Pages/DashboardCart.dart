import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../Controllers/CartController.dart';
import '../../Controllers/UserProfileController.dart';
import '../../Models/Item.dart';
import '../../Services/UserDBService.dart';
import '../../UIWidgets/SelectAddressDialog.dart';
import '../OrderSuccessfullPage.dart';

class DashboardCart extends StatefulWidget {
  @override
  _DashboardCartState createState() => _DashboardCartState();
}

class _DashboardCartState extends State<DashboardCart> {
  final CartController cartController = Get.find();
  final UserProfileController userProfileController = Get.find();
  final payondeliverycheck = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {
                      cartController.cart.deleteAllCart();
                      cartController.getTotalItems();
                    },
                    icon: Icon(
                      Icons.clear_all_sharp,
                      size: 30,
                    )),
              )
            ],
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Obx(
              () => cartController.cartitemcount.value != 0
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.builder(
                        itemCount: cartController.cart.cartItem.length,
                        itemBuilder: (context, index) {
                          print(cartController.cart.cartItem[index].quantity);
                          var item = (cartController.cart.cartItem[index]
                                  .productDetails.item as Item)
                              .obs;
                          var subtotal =
                              (cartController.cart.cartItem[index].subTotal);
                          var quantity =
                              cartController.cart.cartItem[index].quantity;
                          print(
                              "item description:${item.value.description} subtotal:$subtotal quantity:$quantity");
                          return Container(
                            height: Get.context.height * 0.1,
                            width: Get.context.width,
                            child: Card(
                                elevation: 9,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 10),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Text(
                                              item.value.name,
                                              style: GoogleFonts.nunitoSans(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item.value.description,
                                                style: GoogleFonts.nunitoSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                "from " + item.value.restname,
                                                style: GoogleFonts.nunitoSans(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        quantity.toString() +
                                            " X " +
                                            item.value.price.toString() +
                                            " = " +
                                            subtotal.toString(),
                                        style: GoogleFonts.titilliumWeb(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          width: Get.context.width * 0.2,
                                          child: Row(
                                            // mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                  child: IconButton(
                                                      onPressed: () {
                                                        cartController.cart
                                                            .incrementItemToCart(
                                                                cartController
                                                                    .cart
                                                                    .findItemIndexFromCart(item
                                                                        .value
                                                                        .catid));
                                                        setState(() {});
                                                        cartController
                                                            .getTotalItems();
                                                      },
                                                      icon: Icon(Icons
                                                          .add_circle_outline))),
                                              Expanded(
                                                  flex: 0,
                                                  child: Text(
                                                      quantity.toString())),
                                              Expanded(
                                                  child: IconButton(
                                                      onPressed: () {
                                                        cartController.cart
                                                            .decrementItemFromCart(
                                                                cartController
                                                                    .cart
                                                                    .findItemIndexFromCart(item
                                                                        .value
                                                                        .catid));
                                                        cartController
                                                            .getTotalItems();
                                                        setState(() {});
                                                      },
                                                      icon: Icon(Icons
                                                          .remove_circle_outline_outlined)))
                                            ],
                                          ),
                                        ))
                                  ],
                                )),
                          );
                        },
                      ))
                  : Center(
                      child: Text("No Items added to cart"),
                    ),
            ),
            Obx(() => cartController.cartitemcount.value != 0
                ? Positioned(
                    bottom: 0,
                    child: Container(
                      height: Get.context.height * 0.25,
                      width: Get.context.width,
                      color: Colors.yellow,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 50, top: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 0,
                                      child: RoundCheckBox(
                                        isChecked: payondeliverycheck.value,

                                        onTap: (value) {
                                          payondeliverycheck.value = true;
                                          print(value);
                                        },
                                        // checkedWidget: Text("Cash On Delivery"),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Pay On Delivery",
                                              style: GoogleFonts.titilliumWeb(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                )),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: Get.context.height * 0.11,
                                  left: 40,
                                  right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Obx(() => Text(
                                          "Address: ${userProfileController.usercurrentaddress.value}",
                                          style: GoogleFonts.titilliumWeb(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)))),
                                  Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "Select Address",
                                            content: SelectAddressDialog(),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.indigo),
                                        child: Text(
                                          "Select Address",
                                          style: GoogleFonts.titilliumWeb(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: Get.context.height * 0.04, left: 10),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Obx(() => Text(
                                              "Total Items: ${cartController.cartitemcount.value}",
                                              style: GoogleFonts.titilliumWeb(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Total Price: ${cartController.cart.getTotalAmount()}",
                                        style: GoogleFonts.titilliumWeb(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, top: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple),
                                onPressed: () async {
                                  var currentaddress = userProfileController
                                      .usercurrentaddress.value;

                                  var orderstatus = "Placed";
                                  var paymenttype = "COD";
                                  var restid = (cartController.cart.cartItem
                                          .last.productDetails.item as Item)
                                      .restid;
                                  var totalprice =
                                      cartController.cart.getTotalAmount();
                                  var totalquantity =
                                      cartController.cartitemcount.value;
                                  if (currentaddress.isBlank) {
                                    print("address cannot be blank");
                                    AwesomeDialog(
                                        context: Get.context,
                                        dialogType: DialogType.ERROR,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Adress cannot be blank',
                                        desc: 'Please select an adress....',
                                        dismissOnBackKeyPress: true,
                                        dismissOnTouchOutside: true)
                                      ..show();
                                  } else {
                                    var orderid = await UserDBService()
                                        .addOrder(
                                            address: currentaddress,
                                            orderstatus: orderstatus,
                                            paymenttype: paymenttype,
                                            restid: restid,
                                            totalprice: totalprice.toString(),
                                            totalquantity: totalquantity,
                                            userid: FirebaseAuth
                                                .instance.currentUser.uid);

                                    if (orderid.isBlank || orderid == null) {
                                      print("Order Failed");
                                      AwesomeDialog(
                                          context: Get.context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Order Failed',
                                          desc:
                                              'Order Failed due to blank orderid $orderid',
                                          dismissOnBackKeyPress: true,
                                          dismissOnTouchOutside: true,
                                          showCloseIcon: true)
                                        ..show();
                                    } else {
                                      print("Order id $orderid placed");
                                      cartController.cart.deleteAllCart();
                                      cartController.getTotalItems();
                                      Get.offAll(() => OrderSuccessfullPage(
                                            orderid: orderid,
                                          ));
                                    }
                                  }
                                },
                                child: Text(
                                  "Order Now",
                                  style: GoogleFonts.titilliumWeb(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
                : Container(
                    height: 0,
                    width: 0,
                  ))
          ],
        ),
      ),
    );
  }
}
