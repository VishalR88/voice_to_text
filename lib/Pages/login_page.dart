import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_to_text/Constant/ApiConstants.dart';
import 'package:voice_to_text/Pages/forgot_password_page.dart';
import 'package:voice_to_text/Pages/registerPage.dart';
import 'package:voice_to_text/Services/firebase_auth_service.dart';
import 'package:voice_to_text/Widget/btn_widget.dart';
import 'package:voice_to_text/Widget/email_textField_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_service.dart';
import 'Audio_Record_screen.dart';
import 'MobilLoginScreen.dart';
import 'dart:io';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  FirebaseConnection fconnection = FirebaseConnection();
  bool gbtnprogress = false;
  bool isLoading = false;
  bool showHide = true;

  togglepsd() {
    setState(() {
      showHide = !showHide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: const [
                        Text(
                          "Login to continue",
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
                // height: MediaQuery.of(context).size.height/0.,
                // alignment: Alignment.topLeft,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  EmailFieldWidget(
                                    validators: (value) {
                                      if (value!.isEmpty) {
                                        return "*please enter email id";
                                      } else {
                                        return EmailValidator.validate(value) ? null : "*Please enter a valid email";
                                      }
                                    },
                                    obscuretxt: false,
                                    controller: _emailController,
                                    icon: Icons.email,
                                    readOnly: false,
                                    hint: "Email",
                                    keyboardTYPE: TextInputType.emailAddress,
                                    showHide: false,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  EmailFieldWidget(
                                    validators: (value) {
                                      if (value!.isEmpty) {
                                        return "*please enter Password";
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscuretxt: showHide,
                                    controller: _passwordController,
                                    icon: Icons.password,
                                    readOnly: false,
                                    hint: "Password",
                                    keyboardTYPE: TextInputType.visiblePassword,
                                    showHide: showHide,
                                    ontapofsuffixicon: () {
                                      togglepsd();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => ForgotPasswordPage()));
                          },
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: const Text(
                                "Forgot password ?",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BtnWidget(
                          lable: "Login",
                          isLoading: isLoading,
                          ontap: () async {
                            if (_formKey.currentState?.validate() == true) {
                              setState(() {
                                isLoading = true;
                              });
                              SignInAPI();
                              // UserCredential cred;
                              // try {
                              //   cred = await FirebaseAuth.instance
                              //       .signInWithEmailAndPassword(
                              //           email: _emailController.text,
                              //           password: _passwordController.text);
                              //   if (cred.toString() != null) {
                              //     afterLogin(FirebaseAuth.instance.currentUser);
                              //   }
                              //   print(cred);
                              // } on FirebaseAuthException catch (authError) {
                              //   setState(() {
                              //     isLoading = false;
                              //   });
                              //   Fluttertoast.showToast(msg: authError.message.toString());
                              //   if (authError.toString() ==
                              //       "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
                              //     ScaffoldMessenger.of(context)
                              //         .clearSnackBars();
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //         content: Text("User not found"),
                              //       ),
                              //     );
                              //   }
                              // } catch (e) {
                              //   setState(() {
                              //     isLoading = false;
                              //   });
                              //   ScaffoldMessenger.of(context).clearSnackBars();
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(content: Text(e.toString())));
                              // }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => RegisterPage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Don't have an account ? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "OR",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      height: 24,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => MobileLogInPage()));
                        },
                        child: Container(
                          height: 45,
                          width: 215,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                                color: Colors.black87.withOpacity(0.1)),
                          ),
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.phone_android),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  'Continue with phone',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            gbtnprogress = true;
                          });
                          try {
                            final result =
                                await InternetAddress.lookup('example.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              print('connected');
                              await AuthClass()
                                  .googleSignin(context)
                                  .whenComplete(() {
                                setState(() {
                                  gbtnprogress = false;
                                });
                              }).onError((error, stackTrace) {
                                setState(() {
                                  gbtnprogress = false;
                                });
                              });
                            }
                          } on SocketException catch (_) {
                            setState(() {
                              gbtnprogress = false;
                            });
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "There is no internet connection , please turn on your internet.")));
                          }
                        },
                        child: Container(
                          height: 45,
                          width: 215,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                                color: Colors.black87.withOpacity(0.1)),
                          ),
                          padding: const EdgeInsets.only(right: 7),
                          child: gbtnprogress
                              ? const Center(
                                  child: CircularProgressIndicator(
                                  color: Colors.black87,
                                ))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/google.png',
                                      height: 30,
                                      width: 30,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Continue with google',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void afterLogin(res) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email',res['data']['email']);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (builder) => AudioRecoedScreen()),
        (route) => false);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }
  Future<void> SignInAPI() async {
    final uri = Uri.parse(APIConstants.BaseURL+APIConstants.SignIn);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "email":_emailController.text,
      "password":_passwordController.text
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;
    var res = jsonDecode(responseBody);
    if (statusCode == 200) {
      if(res['message']=="Invalid Password"){
        setState(() {
          isLoading= false;
        });
        Fluttertoast.showToast(msg: res['message']);
      }
      else if (res['message']=="Invalid Email"){
        setState(() {
          isLoading= false;
        });
        Fluttertoast.showToast(msg: res['message']);
      }
      else{
        if(res['message'] == "Login successful"){
          setState(() {
            isLoading= false;
          });
          afterLogin(res );
          Fluttertoast.showToast(msg: res['message']);
        }
        Fluttertoast.showToast(msg: res['message']);
      }


    } else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }
}
