import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:voice_to_text/Model/API_class.dart';
import 'package:voice_to_text/Pages/login_page.dart';
import 'package:voice_to_text/Pages/new_password_page.dart';
import 'package:voice_to_text/Widget/progress_indicator.dart';

class VerifyOtp extends StatefulWidget {
  VerifyOtp({
    Key? key,
    required this.fromScreen,
    this.email,
  }) : super(key: key);
  String fromScreen;
  String? email;

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool waiting = false;
  String? enteredOTP;
  bool isLoading = false;
  Color resendOTPcolor = Colors.grey;

  @override
  void initState() {
    inittimeofOTP();
    super.initState();
  }

  void inittimeofOTP() {
    Future.delayed(const Duration(minutes: 3), () {
      setState(() {
        waiting = true;
        resendOTPcolor = Colors.green;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              // Container(
              //   width: 200,
              //   height: 200,
              //   decoration: BoxDecoration(
              //     color: Colors.deepPurple.shade50,
              //     shape: BoxShape.circle,
              //   ),
              //   // child: Image.asset(
              //   //   'images/illustration-3.png',
              //   // ),
              // ),
              // const SizedBox(
              //   height: 24,
              // ),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            child: Form(
                              key: formKey,
                              child: PinCodeTextField(
                                appContext: context,
                                // pastedTextStyle: TextStyle(
                                //   color: c,
                                //   fontWeight: FontWeight.bold,
                                // ),
                                length: 6,
                                // obscureText: true,
                                obscuringCharacter: '*',
                                // obscuringWidget: FlutterLogo(
                                //   size: 24,
                                // ),
                                // blinkWhenObscuring: true,
                                // animationType: AnimationType.fade,
                                validator: (v) {
                                  if (v!.length < 6) {
                                    return "OTP must be 6 digits";
                                  } else {
                                    return null;
                                  }
                                  return null;
                                },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeColor: Colors.blue,
                                  selectedColor: Colors.grey,
                                  inactiveColor: Colors.black,
                                  disabledColor: Colors.grey,
                                  activeFillColor: Colors.blue,
                                  selectedFillColor: Colors.white,
                                  inactiveFillColor: Colors.white,
                                  errorBorderColor: Colors.red,
                                ),
                                cursorColor: Colors.white,
                                animationDuration:
                                    const Duration(milliseconds: 30),
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                controller: textEditingController,
                                keyboardType: TextInputType.number,
                                // boxShadows: [
                                //   BoxShadow(
                                //     offset: Offset(0, 1),
                                //     color: Colors.black12,
                                //     blurRadius: 10,
                                //   )
                                // ],
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                // onTap: () {
                                //   print("Pressed");
                                // },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    enteredOTP = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  return false;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate() &&
                              isLoading == false) {
                            setState(() {
                              isLoading = true;
                            });
                            if (widget.fromScreen == "Registration") {
                              var response = await API()
                                  .VerifyOTP("${widget.email}", "$enteredOTP");
                              print(response);
                              int statusCode = response.statusCode;
                              String responseBody = response.body;
                              var res = jsonDecode(responseBody);
                              if (responseBody.isNotEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              if (statusCode == 200) {
                                Fluttertoast.showToast(
                                    msg:
                                        "${res['message']},Registered Successfully!");
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => LogInPage()),
                                    (route) => false);
                              } else if (statusCode == 400) {
                                Fluttertoast.showToast(msg: res['message']);
                              } else if (statusCode == 401) {
                                Fluttertoast.showToast(
                                    msg: "Internal Server Error !!!");
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "${response.statusCode.toString()}, $res['message]");
                              }
                            }
                            else if (widget.fromScreen == "Forgot Password") {
                              var response = await API()
                                  .VerifyOTP("${widget.email}", "$enteredOTP");
                              print(response);

                              int statusCode = response.statusCode;
                              String responseBody = response.body;
                              var res = jsonDecode(responseBody);
                              if (responseBody.isNotEmpty) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              if (statusCode == 200) {
                                Fluttertoast.showToast(msg: res['message']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => NewPasswordPage(
                                            emailID: widget.email)));
                              } else if (statusCode == 400) {
                                Fluttertoast.showToast(msg: res['message']);
                              } else if (statusCode == 401) {
                                Fluttertoast.showToast(
                                    msg: "Internal Server Error !!!");
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "${response.statusCode.toString()}, $res['message]");
                              }
                            }
                          }
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: isLoading
                            ? const CircilarprogressIndicator()
                            : const Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  "Verify",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              GestureDetector(
                onTap: () async {
                  if (waiting == true && isLoading == false) {
                    setState(() {
                      isLoading = true;
                      waiting = false;
                      resendOTPcolor = Colors.grey;
                    });
                    inittimeofOTP();
                    var response = await API().SendOTP("${widget.email}");
                    print(response);
                    int statusCode = response.statusCode;
                    String responseBody = response.body;
                    var res = jsonDecode(responseBody);
                    if (responseBody.isNotEmpty) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                    if (statusCode == 200) {
                      Fluttertoast.showToast(msg: res['message']);
                    } else if (statusCode == 401) {
                      Fluttertoast.showToast(msg: "Internal Server Error !!!");
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "${response.statusCode.toString()}, $res['message]");
                    }
                  } else {}
                },
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: resendOTPcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
