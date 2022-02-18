import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voice_to_text/Model/API_class.dart';
import 'package:voice_to_text/Pages/registerPage.dart';
import 'package:voice_to_text/Pages/verify_otp.dart';
import 'package:voice_to_text/Widget/btn_widget.dart';
import 'package:voice_to_text/Widget/email_textField_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool gbtnprogress = false;
  bool isLoading = false;

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
                      "Forgot password ?",
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
                          "Verify your email",
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
                                return "*Please enter email id";
                              } else {
                                return EmailValidator.validate(value)
                                    ? null
                                    : "*Please enter a valid email";
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BtnWidget(
                      lable: "Verify email",
                      isLoading: isLoading,
                      ontap: () async {
                        if (_formKey.currentState?.validate() == true&& isLoading == false) {
                          setState(() {
                            isLoading = true;
                          });
                          var response = await API()
                              .ForgotPasswordAPI(_emailController.text);
                          int statusCode = response.statusCode;
                          String responseBody = response.body;
                          var res = jsonDecode(responseBody);
                          if (statusCode == 200) {
                            setState(() {
                              isLoading = false;
                            });
                            Fluttertoast.showToast(msg: res['message']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => VerifyOtp(
                                          fromScreen: "Forgot Password",
                                          email: _emailController.text,
                                        )));
                          } else if (statusCode == 400) {
                            setState(() {
                              isLoading = false;
                            });
                            if(res['message'] == "User not exists"){
                              show_dialogue();
                              Fluttertoast.showToast(msg: res['message']);
                            }
                            else{
                              Fluttertoast.showToast(msg: res['message']);
                            }

                          } else if (statusCode == 401) {
                            Fluttertoast.showToast(
                                msg: "Internal Server Error !!!");
                          } else {
                            Fluttertoast.showToast(
                                msg: response.statusCode.toString());
                          }
                        }
                      },
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
  show_dialogue(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("User not exists !!!"),
            content: const Text("Do you want to register ?"),
            actions: <Widget>[
              FlatButton(
                child: const Text("YES"),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const RegisterPage()));
                },
              ),
              FlatButton(
                child: const Text("NO"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
}
