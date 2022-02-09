import 'package:flutter/material.dart';

import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/UserDBService.dart';

class AddAddressDialog extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  static final addresscontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.context.height * 0.2,
      width: Get.context.width * 0.8,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Add a Address",
                style: GoogleFonts.workSans(
                    fontWeight: FontWeight.bold, fontSize: 18),
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: addresscontroller,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      validator: ValidationBuilder().minLength(6).build(),
                      onSaved: (newValue) => addresscontroller.text = newValue,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        alignLabelWithHint: true,
                        counterStyle: TextStyle(color: Colors.blueAccent),
                        hintText: "Enter Full Address",
                        labelText: "Address",
                        labelStyle: TextStyle(color: Colors.blueAccent),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              var address = addresscontroller.text;
                              if (await UserDBService()
                                  .isExistingAddress(address)) {
                                Get.snackbar(
                                    "Already added", "$address added already");
                              } else {
                                var isAdded = await UserDBService()
                                    .addAddress(address: address);

                                if (isAdded) {
                                  Get.back();
                                  Get.snackbar(
                                      "Added", "Pin Added Successfully");
                                } else {
                                  print("Failed to add");
                                  Get.snackbar("Failed", "Failed to add");
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 8,
                              primary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              )),
                          child: Text("Add Address")),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
