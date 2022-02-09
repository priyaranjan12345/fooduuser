import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pandabar/pandabar.dart';

import '../Controllers/DashboardController.dart';

class DashBoardPage extends StatelessWidget {
  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //extendBodyBehindAppBar: true,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: PandaBar(
        fabIcon: Icon(
          Icons.shopping_cart_outlined,
          color: Colors.white,
        ),
        buttonData: [
          PandaBarButtonData(
            id: 0,
            icon: Icons.near_me,
            title: 'Near By Restaurants',
          ),
          // PandaBarButtonData(
          //     id: 1,
          //     icon: Icons.favorite_outline_outlined,
          //     title: 'Favourites'),
          PandaBarButtonData(
            id: 2,
            icon: Icons.shopping_bag,
            title: 'Orders',
          ),
          PandaBarButtonData(
            id: 3,
            icon: Icons.person_outline_outlined,
            title: 'Profile',
          ),
        ],
        onChange: (id) {
          print(id);
          dashboardController.currentindex.value = id;
        },
        onFabButtonPressed: () {
          //dashboardController.currentindex.value = 4;
          Get.toNamed("/cart");
          print("Cart");
        },
      ),
      body: Obx(() => dashboardController
          .bodypages[dashboardController.currentindex.value]),
    );
  }
}
