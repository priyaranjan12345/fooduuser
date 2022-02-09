import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../Services/LocationService.dart';
import '../Services/UserDBService.dart';

class HomeController extends GetxController {
  var address = "".obs;
  var latitude = (0.0).obs;
  var longitude = (0.0).obs;
  var postalcode = "".obs;
  setLocationData(Position position) async {
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(position.latitude, position.longitude));
    var first = addresses.first;
    postalcode.value = first.postalCode;
    address.value = first.addressLine;
    await UserDBService().updateLocation(
        pincode: postalcode.value,
        longitude: longitude.value,
        latitude: latitude.value,
        currentaddress: address.value);
  }

  @override
  void onInit() async {
    super.onInit();
    var position = await getPosition();

    if (FirebaseAuth.instance.currentUser != null) {
      setLocationData(position);
    }
  }
}
