import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:get/get.dart';

import '../Models/CartItem.dart';

class CartController extends GetxController {
  final cart = FlutterCart();
  final cartitemcount = 0.obs;
  addToCart(CartItem cartItem) {
    if (!checkSameRestaurant(cartItem)) {
      print("Same restaurant product can be added");
      var existingitemindex = cart.findItemIndexFromCart(cartItem.item.catid);
      print("existing itemindex $existingitemindex");
      if (existingitemindex == null) {
        cart.addToCart(
            productId: cartItem.item.catid,
            unitPrice: cartItem.item.price,
            quantity: cartItem.quantity,
            productDetailsObject: cartItem);
      } else {
        cart.incrementItemToCart(existingitemindex);
      }

      print("total amount " + cart.getTotalAmount().toString());
      getTotalItems();
    } else {
      print("Other restaurant product  cannot be added");
      AwesomeDialog(
          context: Get.context,
          dialogType: DialogType.WARNING,
          animType: AnimType.SCALE,
          title: 'Cannot add to cart',
          desc:
              'You cannot add product from different restaurant.\nDo you want to clear the cart !',
          showCloseIcon: true,
          // btnCancelOnPress: () {
          //   Get.back();
          // },
          btnOkOnPress: () {
            cart.deleteAllCart();
            getTotalItems();
          },
          dismissOnBackKeyPress: true,
          dismissOnTouchOutside: true)
        ..show();
    }
  }

  getTotalItems() {
    print("total items");
    cartitemcount.value = 0;
    cart.cartItem.forEach((element) {
      cartitemcount.value += element.quantity;
    });
  }

  bool checkSameRestaurant(CartItem cartItem) {
    if (cart.getCartItemCount() != 0) {
      var mitem = cart.cartItem.last.productDetails as CartItem;
      print(
          "restid: ${cartItem.item.restid} lenght${cartItem.item.restid.length}  previous:  ${mitem.item.restid}  lenght${mitem.item.restid.length}} ");
      if (cartItem.item.restid.compareTo(mitem.item.restid) == 0) {
        return false;
      } else
        print("Not same restaurant");
      return true;
    }
    return false;
  }
}
