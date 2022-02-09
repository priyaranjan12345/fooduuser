import 'package:get/get.dart';

import '../Pages/Dashboard%20Pages/DashboardFavourite.dart';
import '../Pages/Dashboard%20Pages/DashboardHome.dart';
import '../Pages/Dashboard%20Pages/DashboardOrders.dart';
import '../Pages/Dashboard%20Pages/DashboardProfile.dart';

class DashboardController extends GetxController {
  var currentindex = 0.obs;
  var bodypages = [
    DashboardHome(),
    DashboardFavourite(),
    DashboardOrders(),
    DashboardProfile(),
  ];
}
