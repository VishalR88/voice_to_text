import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../firebase_service.dart';
import 'otp.dart';

class MobileLogInPage extends StatefulWidget {

  @override
  _MobileLogInPageState createState() => _MobileLogInPageState();
}

class _MobileLogInPageState extends State<MobileLogInPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _phoneNumber = TextEditingController();
  bool _isLoggedIn = false;
  bool _otpSent = false;
  bool _pressed = false;
  late String _uid;
  String _verificationID = "";

  FirebaseConnection fconnection = FirebaseConnection();

  Future<void> _performSendOTP(String number) async {
    print(number);
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91$number",
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
  void verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        _isLoggedIn = true;
        _uid = FirebaseAuth.instance.currentUser!.uid;

      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("There was problem while sending OTP"),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }
  void verificationFailed(FirebaseAuthException authException) {
    print("exceptionisHere${authException}");
    setState(() {
      _isLoggedIn = false;
      _otpSent = false;
      _uid = "";
      _verificationID="";
      _pressed=false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
        Text("We have blocked all requests from this device due to unusual activity. Try again later."),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }
  void codeSent(String verificationId, [int? smsCode]) async {
    setState(() {
      _verificationID = verificationId;
      _otpSent = false;
      _uid = "";
      _isLoggedIn = false;
      _pressed=false;

      if(_verificationID.isNotEmpty)
        _moveToOTPScreen();
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
  void _moveToOTPScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Otp(_verificationID,_phoneNumber.text)),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
           flex: 1,
              child: Container(
                padding: const EdgeInsets.all(30),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: const[
                         Text(
                          "Please Enter Your Number",
                          style: TextStyle(
                              color: Color(0xFF616161),
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                        ),
                         SizedBox(
                          width: 12,
                        ),
                         Icon(Icons.arrow_forward)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withOpacity(0.3),
                        blurRadius: 14,
                        offset: const Offset(5, 5),
                      ),
                    ]),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _phoneNumber,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(10),
                      ],
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.grey),
                        hintText: "Enter phone number",
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              '+91 ',
                              style: TextStyle(fontSize: 18.0),
                            )),

                        // suffixIcon: Icon(
                        //   Icons.check_circle,
                        //   color: Colors.green,
                        //   size: 32,
                        // ),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    _pressed && _otpSent==false? const CircularProgressIndicator():
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async{
                          try {
                            final result = await InternetAddress.lookup('example.com');
                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                              print('connected');
                              setState(() {
                                if(_phoneNumber.text.isNotEmpty&&_phoneNumber.text.length == 10)
                                  _pressed=true;
                              });
                              if (_phoneNumber.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: const Text("Field can not be empty"),
                                    duration: const Duration(milliseconds: 1000),
                                  ),
                                );
                              } else if (_phoneNumber.text.length != 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                    const Text("Number length should be in 10 digit"),
                                    duration: const Duration(milliseconds: 1000),
                                  ),
                                );
                              } else {
                                _performSendOTP(_phoneNumber.text);
                              }

                              }
                          } on SocketException catch (_) {

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("There is no internet connection , please turn on your internet.")));
                          }


                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child:  Text(
                            'Send',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
