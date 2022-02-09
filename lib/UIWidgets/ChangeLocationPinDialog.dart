import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:form_validator/form_validator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../Controllers/HomeController.dart';

class ChangeLocationPinDialog extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  //

  static final pincontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.context.height * 0.3,
      width: Get.context.width * 0.8,
      child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              pinextfield(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        print(pincontroller.text);
                        var pin = pincontroller.text;
                        final HomeController homecontroller = Get.find();
                        var listaddr =
                            await Geocoder.local.findAddressesFromQuery(pin);
                        var addr = listaddr.first;
                        var coordinates = addr.coordinates;
                        // ignore: missing_required_param
                        await homecontroller.setLocationData(Position(
                          longitude: coordinates.longitude,
                          latitude: coordinates.latitude,
                          accuracy: 10,
                        ));
                        Get.close(2);
                      }
                    },
                    child: Text("Set PIN")),
              )
            ],
          )),
    );
  }

  TextFormField pinextfield() {
    return TextFormField(
      controller: pincontroller,
      keyboardType: TextInputType.number,
      obscureText: false,
      maxLength: 6,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      validator: ValidationBuilder()
          .minLength(6)
          .maxLength(6)
          .add((value) => pinvalidator(value))
          .build(),
      onSaved: (newValue) => pincontroller.text = newValue,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: Colors.blueAccent),
        hintText: "Enter PIN",
        labelText: "Pin",
        labelStyle: TextStyle(color: Colors.blueAccent),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  pinvalidator(String value) {
    if (value.isNum)
      return null;
    else
      return "Error";
  }
}
