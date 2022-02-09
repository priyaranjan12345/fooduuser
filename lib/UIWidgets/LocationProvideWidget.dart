import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Controllers/HomeController.dart';
import '../Services/LocationService.dart';
import 'ChangeLocationPinDialog.dart';

class LocationProviderWidget extends StatefulWidget {
  @override
  _LocationProviderWidgetState createState() => _LocationProviderWidgetState();
}

class _LocationProviderWidgetState extends State<LocationProviderWidget> {
  final HomeController homeController = Get.find();
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = HashSet<Marker>();

  final int _markerIdCounter = 1;

  Widget build(BuildContext context) {
    // _markers.add(Marker(
    //   markerId: MarkerId(_markerIdCounter.toString()),
    //   position:
    //       LatLng(homeController.latitude.value, homeController.longitude.value),
    //   infoWindow: InfoWindow(title: 'Hey'),
    //   draggable: true,
    // ));
    Future.delayed(Duration(milliseconds: 0), () async {
      var position = await getPosition();
      await homeController.setLocationData(position);
      _markers.add(Marker(
        markerId: MarkerId(_markerIdCounter.toString()),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Hey'),
        draggable: true,
      ));
    });

    return Container(
        height: Get.context.height * 0.9,
        color: Colors.white,
        child: ListView(
          children: [
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Current location",
                    style: GoogleFonts.sourceSansPro(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                width: Get.width,
                child: Obx(() => GoogleMap(
                      mapType: MapType.hybrid,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(homeController.latitude.value,
                            homeController.longitude.value),
                        zoom: 14.4746,
                      ),
                      buildingsEnabled: true,
                      compassEnabled: true,
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) async {
                        _controller.complete(controller);
                        var position = await getPosition();
                        _markers.add(Marker(
                          markerId: MarkerId(_markerIdCounter.toString()),
                          position:
                              LatLng(position.latitude, position.longitude),
                          infoWindow:
                              InfoWindow(title: 'The title of the marker'),
                        ));
                      },
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    var position = await getPosition();
                    final GoogleMapController controller =
                        await _controller.future;
                    _markers.add(Marker(
                      markerId: MarkerId(_markerIdCounter.toString()),
                      position: LatLng(position.latitude, position.longitude),
                      infoWindow: InfoWindow(title: 'Hey'),
                      draggable: true,
                    ));
                    await controller.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            bearing: 192.8334901395799,
                            target:
                                LatLng(position.latitude, position.longitude),
                            tilt: 59.440717697143555,
                            zoom: 19.151926040649414)));
                    //setState(() {});
                    await homeController.setLocationData(position);
                    print(homeController.postalcode);
                    // Get.back();
                  },
                  child: Text("Set my location")),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () async {
                    await Get.defaultDialog(
                        title: "", content: ChangeLocationPinDialog());
                    //Get.to(()=>ChangePlaceManually());
                  },
                  child: Text("Change Manually")),
            )
          ],
        ));
  }
}
