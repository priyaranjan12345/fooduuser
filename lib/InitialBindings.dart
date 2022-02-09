import 'package:get/get.dart';

import 'Controllers/CartController.dart';
import 'Controllers/DashboardController.dart';
import 'Controllers/HomeController.dart';
import 'Controllers/RestaurantConrtoller.dart';
import 'Controllers/UserProfileController.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CartController());
    Get.put(RestaurantController());
    Get.put(UserProfileController());
    Get.put(HomeController());
    Get.put(DashboardController());
  }
}
