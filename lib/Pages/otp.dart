import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_to_text/Model/login_model.dart';

import 'Audio_Record_screen.dart';

class Otp extends StatefulWidget {
  String _verificationId, _phoneNumber;

  Otp(this._verificationId, this._phoneNumber);

  @override
  _OtpState createState() => _OtpState(this._verificationId, this._phoneNumber);
}

class _OtpState extends State<Otp> {
  String _verificationId, _phoneNumber;
  late BuildContext _context;
  String _otp = "";
  bool _isLoggedIn = false;
  bool _pressed = false;
  String _uid = "";
  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  _OtpState(this._verificationId, this._phoneNumber);

  void callUserLogin(String phoneNumber, String password) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email',phoneNumber);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>AudioRecoedScreen()),
    );
  }
  void _verifyOTP() async {
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _otp);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser != null) {
        // ScaffoldMessenger.of(_context).showSnackBar(
        //   SnackBar(
        //     content: Text("User registered successfully"),
        //     duration: Duration(milliseconds: 1000),
        //   ),
        // );

        setState(() {
          _isLoggedIn = true;
          _uid = FirebaseAuth.instance.currentUser!.uid;

          _pressed = false;
        });
         callUserLogin(_phoneNumber, _otp);
      } else {
        setState(() {
          _isLoggedIn = false;
          _uid = "";

          _pressed = false;
        });
        ScaffoldMessenger.of(_context).showSnackBar(
          SnackBar(
            content: Text("OTP is wrong"),
            duration: Duration(milliseconds: 1000),
          ),
        );
      }
    } catch (e) {
      print("errorOTPSend ${e.toString()}");

      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text(
              "The sms code has expired. Please re-send the verification code to try again."),
          duration: Duration(milliseconds: 1000),
        ),
      );
      setState(() {
        _isLoggedIn = false;
        _uid = "";
        _pressed = false;
      });
    }
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    _otp = "";
    _isLoggedIn = false;
    _pressed = false;
    _uid = "";
    print(_phoneNumber);
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                // child: Image.asset(
                //   'images/illustration-3.png',
                // ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(28),
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
                                  // if (v!.length < 3) {
                                  //   return "I'm from validator";
                                  // } else {
                                  //   return null;
                                  // }
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
                                animationDuration: Duration(milliseconds: 30),
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
                                    currentText = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return false;
                                },
                              ),
                            ),
                          ),
                          // _textFieldOTP(
                          //   first: true,
                          //   last: false,
                          //   controller: _firstDigit,
                          //   myNode: node1,
                          //   upcomingNode: node2,
                          //   gobackNode: node2,
                          // ),
                          // _textFieldOTP(
                          //   first: false,
                          //   last: false,
                          //   controller: _secondDigit,
                          //   myNode: node2,
                          //   upcomingNode: node3,
                          //   gobackNode: node1,
                          // ),
                          // _textFieldOTP(
                          //     first: false,
                          //     last: false,
                          //     controller: _thirdDigit,
                          //     myNode: node3,
                          //   upcomingNode: node4,
                          //   gobackNode: node2,),
                          // _textFieldOTP(
                          //     first: false,
                          //     last: false,
                          //     controller: _fourthDigit,
                          //     myNode: node4,
                          //   upcomingNode: node5,
                          //   gobackNode: node3,),
                          // _textFieldOTP(
                          //     first: false,
                          //     last: false,
                          //     controller: _fifthDigit,
                          //     myNode: node5,
                          //   upcomingNode: node6,
                          //   gobackNode: node4,),
                          // _textFieldOTP(
                          //     first: false,
                          //     last: true,
                          //     controller: _sixthDigit,
                          //     myNode: node6,
                          //   upcomingNode: node6,
                          //   gobackNode: node5,),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    _pressed && _isLoggedIn == false
                        ? CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (currentText.isNotEmpty) {
                                    _pressed = true;
                                  }
                                });
                                if (currentText.isEmpty) {
                                  setState(() {
                                    _otp = "";
                                    _isLoggedIn = false;
                                    _pressed = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Field can not be empty"),
                                      duration: Duration(milliseconds: 1000),
                                    ),
                                  );
                                } else {
                                  _otp = currentText;
                                  _verifyOTP();
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
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
              SizedBox(
                height: 18,
              ),
              Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 18,
              ),
              _pressed && _isLoggedIn == false
                  ? CircularProgressIndicator()
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLoggedIn = false;
                          _pressed = true;
                        });
                        _performSendOTP();
                      },
                      child: Text(
                        "Resend New Code",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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

  Widget _textFieldOTP(
      {required bool first,
      last,
      required TextEditingController controller,
      required FocusNode myNode,
      required FocusNode upcomingNode,
      required FocusNode gobackNode}) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 65,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: controller,
          autofocus: true,
          focusNode: myNode,
          // onChanged: (text) {
          //   if (text.length == 1) {
          //     FocusScope.of(context).requestFocus(upcomingNode);
          //   }  else if (text.isEmpty) {
          //     FocusScope.of(context).requestFocus(node1);
          //   }
          // },

          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).requestFocus(upcomingNode);
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).requestFocus(gobackNode);
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.blue),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  bool _otpSent = false;

  Future<void> _performSendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91$_phoneNumber",
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void codeSent(String verificationId, [int? smsCode]) async {
    setState(() {
      _verificationId = verificationId;
      _otpSent = false;
      _uid = "";
      _isLoggedIn = false;
      _pressed = false;
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    // setState(() {
    //   _verificationID = verificationId;
    //   _otpSent = true;
    //   _moveToOTPScreen();
    //
    // });
  }

  void verificationFailed(FirebaseAuthException authException) {
    setState(() {
      _isLoggedIn = false;
      _otpSent = false;
      _uid = "";
      _verificationId = "";
      _pressed = false;
    });
    print("objectError${authException.toString()}");
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(
            "We have blocked all requests from this device due to unusual activity. Try again later."),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }

  void verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        _isLoggedIn = false;
        _uid = "";
      });
    } else {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text("There was problem while sending OTP"),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }
}
