import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Services/UserDBService.dart';

enum OrderStatus { Placed, Canceled, Accepted, Preparing, Pickedup, Delivered }

class DashboardOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.context.height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Get.context.height * 0.07,
              child: AppBar(
                centerTitle: true,
                elevation: 9,
                title: Text(
                  "Orders",
                  style: GoogleFonts.lato(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: Get.context.height * 0.05),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("orders")
                    .where('userid',
                        isEqualTo: FirebaseAuth.instance.currentUser.uid)
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.hasData) {
                    var orderdocs = snapshot.data.docs;
                    if (orderdocs.length != 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: orderdocs.length,
                          itemBuilder: (context, index) {
                            var orderdoc = orderdocs[index];
                            var orderid = orderdoc.id;
                            var restid = orderdoc.get('restid');
                            var orderstatus = orderdoc.get('status');
                            Timestamp timestamp = orderdoc.get('time');
                            var datetime = DateFormat.yMMMd()
                                .add_jm()
                                .format(timestamp.toDate());
                            var totalquantity = orderdoc.get('total_quantity');
                            var totalprice = orderdoc.get('total');
                            var paymentType = orderdoc.get('payment_type');
                            return Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ExpansionTile(
                                backgroundColor: Colors.amberAccent,
                                collapsedBackgroundColor: Colors.amber,
                                title: ordersMainContent(
                                    restid,
                                    datetime,
                                    orderid,
                                    orderstatus,
                                    paymentType,
                                    totalquantity,
                                    totalprice),
                                //leading:Text("MY Burron"),
                                subtitle: actionContainer(orderstatus, orderid),

                                children: [allItems(orderid)],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                          child: Text(
                        "No Orders Yet",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ));
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> allItems(String orderid) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("orders")
          .doc(orderid)
          .collection("items")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        if (snapshot.hasData) {
          var items = snapshot.data.docs;
          if (items.length != 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];

                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Text("${item.get('itemname')}"),
                  subtitle: Text("${item.get('description')}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${item.get("quantity")}"),
                      Text("   X   "),
                      Text("₹ ${item.get("itemprice")}"),
                      Text("   =   "),
                      Text(" ₹ ${item.get("subtotal")}"),
                    ],
                  ),
                );
              },
            );
          } else {
            return Text("No Items");
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container actionContainer(orderstatus, orderid) {
    if (orderstatus == "Placed") {
      return Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () async {
                  print("Cancel $orderid");
                  await UserDBService().cancelOrder(orderid);
                },
                child: Text("Cancel  ")),
          ],
        ),
      );
    }
    if (orderstatus == "Accepted") {
      return Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text("Order recieved by restaurant")],
        ),
      );
    }
    if (orderstatus == "Pickedup") {
      return Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () {}, child: Text("Track")),
          ],
        ),
      );
    }
    if (orderstatus == "Preparing") {
      return Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text("Orders is now in restaurants kitchen")],
        ),
      );
    }

    return Container();
  }

  Container ordersMainContent(restid, String datetime, String orderid,
      orderstatus, paymentType, totalquantity, totalprice) {
    return Container(
      height: 120,
      //color: Colors.red,
      child: Card(
        elevation: 9,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: restaurantname(restid),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: orderTime(datetime),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: orderID(orderid),
            ),
            Align(
              alignment: Alignment.topRight,
              child: orderStatus(orderstatus),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Payment : $paymentType"),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Total Quantity: $totalquantity    Total: ₹ $totalprice"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding orderStatus(orderstatus) {
    if (orderstatus == "Placed") {
      return Padding(
        padding: const EdgeInsets.only(right: 5, top: 8),
        child: Text(
          "Status : $orderstatus",
          style: GoogleFonts.nunito(color: Colors.green),
        ),
      );
    }
    if (orderstatus.toString().toLowerCase().contains("cancel")) {
      return Padding(
        padding: const EdgeInsets.only(right: 5, top: 8),
        child: Text(
          "Status : $orderstatus",
          style: GoogleFonts.nunito(color: Colors.red),
        ),
      );
    }
    if (orderstatus == "Accepted") {
      return Padding(
        padding: const EdgeInsets.only(right: 5, top: 8),
        child: Text(
          "Status : $orderstatus",
          style: GoogleFonts.nunito(color: Colors.blue),
        ),
      );
    }
    if (orderstatus == "Preparing") {
      return Padding(
        padding: const EdgeInsets.only(right: 5, top: 8),
        child: Text(
          "Status : $orderstatus",
          style: GoogleFonts.nunito(color: Colors.amber),
        ),
      );
    }
    if (orderstatus == "Pickedup") {
      return Padding(
        padding: const EdgeInsets.only(right: 5, top: 8),
        child: Text(
          "Status : $orderstatus",
          style: GoogleFonts.nunito(color: Colors.purple),
        ),
      );
    }
    if (orderstatus == "Delivered") {
      return Padding(
        padding: const EdgeInsets.only(right: 5, top: 8),
        child: Text(
          "Status : $orderstatus",
          style: GoogleFonts.nunito(color: Colors.indigo),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 5, top: 8),
      child: Text(
        "Status : $orderstatus",
        style: GoogleFonts.nunito(color: Colors.pink),
      ),
    );
  }

  Padding orderID(String orderid) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Order ID:$orderid ",
        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
      ),
    );
  }

  Text orderTime(String datetime) {
    return Text("Time: ${datetime.toString()}");
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> restaurantname(restid) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("restaurants")
          .doc(restid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error in data"));
        }
        if (snapshot.hasData) {
          var isRestdoc = snapshot.data.exists;
          if (isRestdoc) {
            var restdoc = snapshot.data;
            var restname = restdoc.get('userinfo.restaurant_name');
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "From $restname",
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
              ),
            );
          } else
            return Text("No restaurant found");
        }
        return Text("No data");
      },
    );
  }
}
