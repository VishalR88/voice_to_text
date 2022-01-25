import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_to_text/Pages/registerPage.dart';
import 'package:voice_to_text/Widget/btn_widget.dart';
import 'package:voice_to_text/Widget/email_textField_widget.dart';

import '../firebase_service.dart';
import 'Audio_Record_screen.dart';
import 'otp.dart';

class MobileLogInPage extends StatefulWidget {

  @override
  _MobileLogInPageState createState() => _MobileLogInPageState();
}

class _MobileLogInPageState extends State<MobileLogInPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobCintroller = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _genderController = TextEditingController();
  final _locationCOntroller = TextEditingController();
  final _cityController = TextEditingController();
  final _nationalityController = TextEditingController();
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
        SnackBar(
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
      SnackBar(
        content:
        Text("We have blocked all requests from this device due to unusual activity. Try again later."),
        duration: Duration(milliseconds: 1000),
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
                      children: [
                        const Text(
                          "Please Enter Your Number",
                          style: TextStyle(
                              color: Color(0xFF616161),
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "7428730894",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Padding(
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
                    SizedBox(
                      height: 22,
                    ),
                    _pressed && _otpSent==false? CircularProgressIndicator():
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if(_phoneNumber.text.isNotEmpty&&_phoneNumber.text.length == 10)
                              _pressed=true;
                          });
                          if (_phoneNumber.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Field can not be empty"),
                                duration: Duration(milliseconds: 1000),
                              ),
                            );
                          } else if (_phoneNumber.text.length != 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text("Number length should be in 10 digit"),
                                duration: Duration(milliseconds: 1000),
                              ),
                            );
                          } else {

                            _performSendOTP(_phoneNumber.text);
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
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
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