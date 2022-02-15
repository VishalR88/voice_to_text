import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:voice_to_text/Constant/ApiConstants.dart';
import 'package:voice_to_text/Pages/new_password_page.dart';
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
                        if (_formKey.currentState?.validate() == true) {
                          setState(() {
                            isLoading = true;
                          });
                          ForgotPasswordAPI();


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
  Future<void> ForgotPasswordAPI() async {
    final uri = Uri.parse(APIConstants.BaseURL+APIConstants.ForgotPassword);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "email" : _emailController.text,
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
      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => NewPasswordPage()));
      Fluttertoast.showToast(msg: res['message']);
    }
    else if(statusCode== 400){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: res['message']);
    }else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }

}
