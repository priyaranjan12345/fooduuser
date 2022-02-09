import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nice_intro/intro_screen.dart';
import 'package:nice_intro/intro_screens.dart';

import '../Services/HiveDBService.dart';

class AppIntroScreen extends StatelessWidget {
  final List<IntroScreen> pages = [
    IntroScreen(
      title: 'Browse the Menu & Explore Food Nearby',
      headerBgColor: Colors.white,
      imageAsset: 'assets/Introimages/onboarding2.webp',
      description: "Order delicious food from nearby restaurant",
    ),
    IntroScreen(
      title: 'Smart Pay',
      headerBgColor: Colors.white,
      imageAsset: 'assets/Introimages/onboarding3.webp',
      description: "Pay using Cash or UPI on delivery",
    ),
    IntroScreen(
      title: 'Delivery',
      imageAsset: 'assets/Introimages/onboarding1.png',
      description: 'Your order will be immediately collected and delivered',
      headerBgColor: Colors.white,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroScreens(
        footerBgColor: Colors.blueAccent,
        slides: pages,
        onDone: () {
          writeFirstTime();
          Get.offAllNamed("/");
        },
        onSkip: () {
          writeFirstTime();
          Get.offAllNamed("/");
        },
      ),
    );
  }
}
