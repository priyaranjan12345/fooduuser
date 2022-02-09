import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/UserDBService.dart';

class RegisterUserInfo extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  //

  static final pincontroller = TextEditingController();
  static final citycontroller = TextEditingController();
  static final namecontroller = TextEditingController();

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: context.height * 0.8,
          width: context.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Register User Info",
                          style: GoogleFonts.raleway(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 80, horizontal: 20),
                    child: Form(
                        //autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(flex: 3, child: nametextfield()),
                            Expanded(flex: 0, child: registerUserButton())
                          ],
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Container registerUserButton() {
    return Container(
      width: Get.context.width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            var restdbservice = UserDBService();
            if (await restdbservice.checkExistingUser()) {
              Get.toNamed("/dashboard");
            } else {
              var isAccountCreated = await restdbservice.createUserAccount(
                  phoneno: FirebaseAuth.instance.currentUser.phoneNumber,
                  name: namecontroller.text,
                  profileurl: "",
                  locationpin: pincontroller.text,
                  city: citycontroller.text);
              if (isAccountCreated) {
                print("Account created successfully");
                Get.toNamed("/dashboard");
              } else {
                Get.snackbar("Failed", "account creation failed");
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
        child: Text(
          "Sign Up",
          style: GoogleFonts.openSans(fontSize: 20),
        ),
      ),
    );
  }

  TextFormField nametextfield() {
    return TextFormField(
      controller: namecontroller,
      keyboardType: TextInputType.text,
      obscureText: false,
      validator: ValidationBuilder()
          .minLength(3)
          .add((value) => namevalidator(value))
          .build(),
      onSaved: (newValue) => namecontroller.text = newValue,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: Colors.blueAccent),
        hintText: "Enter Your Name",
        labelText: "Name",
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

  String namevalidator(String name) {
    if (name.length < 3) {
      return "Name must be more than 3 character";
    } else if (name.isNum) {
      return "Name must not be a number";
    } else {
      return null;
    }
  }
}
