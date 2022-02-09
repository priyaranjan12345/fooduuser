import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Controllers/CartController.dart';
import '../Controllers/UserProfileController.dart';
import '../Models/Item.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference users = firestore.collection('users');
CollectionReference orders = firestore.collection('orders');
FirebaseAuth auth = FirebaseAuth.instance;
ConfirmationResult confirmationResult;

Future<bool> isUser({String uid}) async {
  var userdocs = await users.where('uid', isEqualTo: uid).get();
  if (userdocs.docs.length == 1) {
    return true;
  } else
    return false;
}

class UserDBService {
  Future<bool> logout() async {
    var isLoggedOut = false;
    await auth.signOut().then((value) => isLoggedOut = true);
    return isLoggedOut;
  }

  Future<bool> checkExistingUser() async {
    var isexistingaccount = false;
    var user = await FirebaseAuth.instance.authStateChanges().first;
    if (user != null) {
      await users.doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          isexistingaccount = true;
        }
      });
    } else {
      print("User not verified yet");
    }

    return isexistingaccount;
  }

  Future<bool> createUserAccount({
    String phoneno,
    String name,
    String profileurl,
    String city,
    String locationpin,
  }) async {
    bool isCreated = false;
    var currentdatetime = DateTime.now();
    var uid = FirebaseAuth.instance.currentUser.uid;
    var userdoc = users.doc(uid);
    await userdoc.set({
      "userinfo": {
        "uid": uid,
        "phoneno": phoneno,
        "name": name,
        "photourl": "",
        "addresses": [],
        "locationpin": locationpin,
        "created_at": currentdatetime.toString(),
      }
    }).then((value) => isCreated = true);

    return isCreated;
  }

  Future<bool> updateProfileImage({String imageurl}) async {
    var isupdated = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var userdoc = users.doc(uid);
    await userdoc.update({"userinfo.photourl": imageurl}).then(
        (value) => isupdated = true);
    return isupdated;
  }

  Future<void> getUserInfo() async {
    final UserProfileController userprofilecontroller = Get.find();
    var uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot userdoc = await users.doc(uid).get();
    print(userdoc.get('userinfo.name'));
    userprofilecontroller.imageurl.value = userdoc.get('userinfo.photourl');
    userprofilecontroller.username.value = userdoc.get('userinfo.name');
  }

  Future<bool> updateLocation(
      {String pincode,
      double longitude,
      double latitude,
      String currentaddress}) async {
    var isupdated = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var userdoc = users.doc(uid);
    await userdoc.update({
      "userinfo.locationpin": pincode,
      "userinfo.geopoint": GeoPoint(latitude, longitude),
      "userinfo.currentaddress": currentaddress
    }).then((value) => isupdated = true);
    return isupdated;
  }

  Future<bool> addAddress({String address}) async {
    var isAdded = false;
    await users.doc(FirebaseAuth.instance.currentUser.uid).update({
      "userinfo.addresses": FieldValue.arrayUnion([address])
    }).then((value) => isAdded = true);
    return isAdded;
  }

  Future<bool> isExistingAddress(String address) async {
    var isexisting = false;
    await users
        .where('userinfo.addresses', arrayContains: address)
        .where('userinfo.uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print("Got same address in dics " + querySnapshot.docs.length.toString());
      // print(querySnapshot.docs.first.id);
      if (querySnapshot.docs.length != 0) {
        isexisting = true;
      } else
        print("Not found");
    });

    return isexisting;
  }

  Future<bool> deletAAddress(String address) async {
    var isdeleted = false;
    await users.doc(FirebaseAuth.instance.currentUser.uid).update({
      "userinfo.addresses": FieldValue.arrayRemove([address])
    }).then((value) => isdeleted = true);
    return isdeleted;
  }

  Future<String> addOrder({
    String userid,
    String restid,
    String totalprice,
    String paymenttype,
    String address,
    int totalquantity,
    String orderstatus,
  }) async {
    var orderid = "";
    final CartController cartController = Get.find();

    print("""userid: $userid restid: $restid totalprice: $totalprice 
        payment type :$paymenttype address: $address 
        totalquantity: $totalquantity orderstatus:$orderstatus""");

    await orders.add({
      "userid": userid,
      "restid": restid,
      "total": totalprice,
      "payment_type": paymenttype,
      "address": address,
      "total_quantity": totalquantity,
      "status": orderstatus,
      "time": DateTime.now()
    }).then((value) => orderid = value.id);
    if (orderid != null || !orderid.isBlank) {
      print("order document added successfully");
      for (int index = 0;
          index < cartController.cart.cartItem.length;
          index++) {
        var item =
            (cartController.cart.cartItem[index].productDetails.item as Item);
        var subtotal = (cartController.cart.cartItem[index].subTotal);
        var quantity = cartController.cart.cartItem[index].quantity;
        print(item.name);
        print(item.price);
        print(quantity);
        print(subtotal);
        print(item.description);
        print(item.restname);
        print(item.itemid);
        print(item.catid);
        await addItemstoOrder(
            orderid: orderid,
            name: item.name,
            price: item.price,
            quantity: quantity,
            subtotal: subtotal,
            description: item.description,
            itemid: item.itemid,
            catid: item.catid);
      }
    } else {
      print("order failed");
    }

    return orderid;
  }

  Future<void> addItemstoOrder(
      {String orderid,
      String name,
      double price,
      int quantity,
      subtotal,
      String description,
      String itemid,
      String catid}) async {
    await orders.doc(orderid).collection("items").add({
      "itemname": name,
      "itemprice": price,
      "quantity": quantity,
      "subtotal": subtotal,
      "description": description,
      "itemid": itemid,
      "catid": catid,
    }).then(
        (value) => ("Item added to order $orderid with itemid ${value.id}"));
  }

  Future<void> cancelOrder(String orderid) async {
    await orders.doc(orderid).update({"status": "Self Cancelled"});
  }
}
