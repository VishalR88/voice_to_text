import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:voice_to_text/Constant/ApiConstants.dart';
import 'package:voice_to_text/Pages/login_page.dart';
import 'package:voice_to_text/Widget/btn_widget.dart';
import 'package:voice_to_text/Widget/email_textField_widget.dart';

class NewPasswordPage extends StatefulWidget {
   NewPasswordPage({Key? key,this.emailID}) : super(key: key);
   String? emailID;
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();
  bool showHidepsd = true;
  bool showHidecpsd = true;
  bool isLoading = false;
  togglepsd() {
    setState(() {
      showHidepsd = !showHidepsd;
    });
  }
  togglecpsd() {
    setState(() {
      showHidecpsd = !showHidecpsd;
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
                      "Set new password",
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
                          "Enter your new password",
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
                                return "*Please enter password";
                              } else {
                                return null;
                              }
                            },
                            obscuretxt: showHidepsd,
                            controller: _passwordController,
                            icon: Icons.password,
                            readOnly: false,
                            hint: "Password",
                            keyboardTYPE: TextInputType.visiblePassword,
                            showHide: showHidepsd,
                            ontapofsuffixicon: () {
                              togglepsd();
                            },
                          ),
                          const SizedBox(height: 15,),
                          EmailFieldWidget(
                            validators: (value) {
                              if (value!.isEmpty) {
                                return "*Please enter password again";
                              }
                              else if(value != _passwordController.text){
                                return '*Password doesn\'t matched';
                              }
                              else {
                                return null;
                              }
                            },
                            obscuretxt: showHidecpsd,
                            controller: _cpasswordController,
                            icon: Icons.password,
                            readOnly: false,
                            hint: "Confirm password",
                            keyboardTYPE: TextInputType.visiblePassword,
                            showHide: showHidecpsd,
                            ontapofsuffixicon: () {
                              togglecpsd();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BtnWidget(
                      lable: "let's go!!!",
                      isLoading: isLoading,
                      ontap: () async {
                        if (_formKey.currentState?.validate() == true) {
                          setState(() {
                            isLoading = true;
                          });
                          ResetPasswordAPI();

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

  Future<void> ResetPasswordAPI() async {
    final uri = Uri.parse(APIConstants.BaseURL+APIConstants.ResetPassword);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "email":widget.emailID,
      "password":_passwordController.text,
      "confirmPassword":_cpasswordController.text,
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
      Fluttertoast.showToast(msg: res['message']);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => LogInPage()),
              (route) => false);
    } else {
      Fluttertoast.showToast(msg: response.statusCode.toString());
    }
  }
}
