import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'InitialBindings.dart';
import 'Pages/Dashboard%20Pages/DashboardCart.dart';
import 'Pages/DashboardPage.dart';
import 'Pages/HomePage.dart';
import 'Pages/IntroScreen.dart';
import 'Pages/LoginPage.dart';
import 'Pages/RegisterUserInfo.dart';
import 'Pages/SplashScreen.dart';
import 'Pages/UnknowPage.dart';
import 'Services/ConnectivityService.dart';

class FooduUserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child),
          defaultScale: true,
          minWidth: 480,
          defaultName: DESKTOP,
          breakpoints: [
            ResponsiveBreakpoint.autoScale(480, name: MOBILE),
            ResponsiveBreakpoint.resize(600, name: MOBILE),
            ResponsiveBreakpoint.resize(850, name: TABLET),
            ResponsiveBreakpoint.resize(1080, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(
            height: Get.height,
            width: Get.width,
            color: Colors.white24,
          )),
      getPages: [
        GetPage(name: "/", page: () => HomePage(), transition: Transition.zoom),
        GetPage(name: "/splash", page: () => SplashScreen()),
        GetPage(name: "/dashboard", page: () => DashBoardPage()),
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/cart", page: () => DashboardCart()),
        GetPage(
            name: "/registerinfo",
            page: () => RegisterUserInfo(),
            transition: Transition.downToUp),
        GetPage(name: "/intro", page: () => AppIntroScreen())
      ],
      initialBinding: InitialBindings(),
      unknownRoute: GetPage(name: "/unknow", page: () => UnknownPage()),
      initialRoute: "/splash",
      onInit: () async {},
      onReady: () => checkconnection(),
    );
  }
}
