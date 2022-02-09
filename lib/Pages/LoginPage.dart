import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../Services/UserDBService.dart';

enum MobileVerificationState { SHOW_MOBILE_FORM_STATE, SHOW_OTP_FORM }

class LoginScreen extends StatefulWidget {
  static final _formkey = GlobalKey<FormState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  var phonenumber = "";
  var otpcontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationid;
  bool _showLoading = false;

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();
  void signInWithPhoneAuhCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      _showLoading = true;
    });
    try {
      final authcredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _showLoading = false;
      });
      if (authcredential.user != null) {
        if (await UserDBService().checkExistingUser()) {
          Get.offAllNamed('/dashboard');
        } else {
          Get.offAllNamed('/registerinfo');
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showLoading = false;
      });
      Get.snackbar("Firebase auth exception", "$e");
    }
  }

  @override
  void dispose() {
    errorController.close();
    otpcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _showLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Loading"),
                )
              ],
            ))
          : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFormWidget()
              : otpScrennDialog(),
    );
  }

  Container getMobileFormWidget() {
    return Container(
      height: Get.context.height,
      width: Get.context.width,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(50),
          color: Colors.white24),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 0,
                    child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        )),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text("Back",
                        style: GoogleFonts.rubik(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              "assets/sideshape.png",
              alignment: Alignment.topRight,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: Get.context.width * 0.3, left: 20),
              child: Text(
                "Welcome \nLets Get Started",
                style: GoogleFonts.ubuntu(fontSize: 35),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  top: Get.context.width * 0.5, left: 20, right: 20),
              child: Form(
                key: LoginScreen._formkey,
                //   autovalidateMode: AutovalidateMode.,
                child: ListView(
                  shrinkWrap: false,
                  children: [
                    IntlPhoneField(
                      countries: ["IN"],
                      validator: ValidationBuilder()
                          .minLength(10, "Must be 10 digit")
                          .maxLength(10)
                          .build(),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                          ),
                        ),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        // print(phone.completeNumber);
                        phonenumber = phone.completeNumber;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.amber),
                        onPressed: () async {
                          if (LoginScreen._formkey.currentState.validate()) {
                            setState(() {
                              _showLoading = true;
                            });
                            await _auth.verifyPhoneNumber(
                              phoneNumber: phonenumber,
                              verificationCompleted:
                                  (phoneAuthCredential) async {},
                              verificationFailed: (error) async {
                                Get.snackbar("Failed", "Failed with $error");
                                setState(() {
                                  _showLoading = false;
                                });
                              },
                              codeSent:
                                  (verificationId, forceResendingToken) async {
                                setState(() {
                                  _showLoading = false;
                                  currentState =
                                      MobileVerificationState.SHOW_OTP_FORM;
                                  this.verificationid = verificationId;
                                });
                              },
                              codeAutoRetrievalTimeout:
                                  (verificationid) async {},
                            );
                          }
                        },
                        child: Text(
                          "Login with Mobile Number",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

//
//
//
  otpScrennDialog() {
    return Container(
        height: Get.context.height,
        width: Get.context.width,
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(50),
            color: Colors.white24),
        child: Stack(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 0,
                    child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        )),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text("Back",
                        style: GoogleFonts.rubik(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              "assets/sideshape.png",
              alignment: Alignment.topRight,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: Get.context.width * 0.3, left: 20),
              child: Text(
                "Enter OTP Sent to \n $phonenumber",
                style: GoogleFonts.ubuntu(fontSize: 35),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    top: Get.context.width * 0.5, left: 20, right: 20),
                child: Form(
                  key: LoginScreen._formkey,
                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    shrinkWrap: false,
                    children: [
                      PinCodeTextField(
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        animationDuration: Duration(milliseconds: 300),
                        errorAnimationController:
                            errorController, // Pass it here
                        controller: otpcontroller,

                        autoDisposeControllers: false,
                        validator: ValidationBuilder()
                            .minLength(6, "Otp Must be six digit")
                            .maxLength(6, "max length exceed")
                            .build(),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.circle,
                          // borderRadius: BorderRadius.circular(5),
                          fieldHeight: 60,
                          fieldWidth: 60,
                        ),
                        errorTextSpace: 40,
                        useHapticFeedback: true,
                        autoFocus: true,
                        keyboardType: TextInputType.number,
                        enableActiveFill: true,
                        enablePinAutofill: true,
                        enabled: true,

                        boxShadows: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onChanged: (value) {
                          print("value changed $value");
                          setState(() {
                            otpcontroller.text = value;
                          });
                        },

                        onTap: () {},

                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                        appContext: context,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.amber),
                          onPressed: () async {
                            if (LoginScreen._formkey.currentState.validate()) {
                              final phoneAuthCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: this.verificationid,
                                      smsCode: otpcontroller.text);
                              signInWithPhoneAuhCredential(phoneAuthCredential);
                            }
                          },
                          child: Text(
                            "Verify",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  setState(() {
                                    _showLoading = true;
                                    otpcontroller.clear();
                                    otpcontroller = TextEditingController();
                                  });
                                  await _auth.verifyPhoneNumber(
                                    phoneNumber: phonenumber,
                                    verificationCompleted:
                                        (phoneAuthCredential) async {},
                                    verificationFailed: (error) async {
                                      Get.snackbar(
                                          "Failed", "Failed with $error");
                                      setState(() {
                                        _showLoading = false;
                                      });
                                    },
                                    codeSent: (verificationId,
                                        forceResendingToken) async {
                                      setState(() {
                                        _showLoading = false;
                                        currentState = MobileVerificationState
                                            .SHOW_OTP_FORM;
                                        this.verificationid = verificationId;
                                      });
                                    },
                                    codeAutoRetrievalTimeout:
                                        (verificationid) async {},
                                  );
                                },
                                child: Text("Resend")),
                            TextButton(
                                onPressed: () async {
                                  otpcontroller.clear();
                                  setState(() {});
                                },
                                child: Text("Clear"))
                          ])
                    ],
                  ),
                ),
              ))
        ]));
  }
}
