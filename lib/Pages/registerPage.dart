import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:voice_to_text/Model/API_class.dart';
import 'package:voice_to_text/Pages/login_page.dart';
import 'package:voice_to_text/Pages/verify_otp.dart';
import 'package:voice_to_text/Widget/btn_widget.dart';
import 'package:voice_to_text/Widget/dropDown_Field.dart';
import 'package:voice_to_text/Widget/email_textField_widget.dart';

import '../firebase_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
  FirebaseConnection fconnection = FirebaseConnection();
  bool isLoading = false;
  bool showHide = true;
  String? gender;

  togglepsd() {
    setState(() {
      showHide = !showHide;
    });
  }

  DateTime selectedDate = DateTime.now();
  String selectd_date = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String formatted = formatter.format(picked);
      if (mounted) {
        setState(() {
          selectd_date = formatted;
        });
      }
    }
  }
  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
  navigateToLoginPage(context){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (builder) => LogInPage()),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>navigateToLoginPage(context),
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
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
                        children: const [
                          Text(
                            "SignUp to continue",
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
                Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      EmailFieldWidget(
                                        controller: _firstNameController,
                                        icon: Icons.supervised_user_circle,
                                        hint: "First name",
                                        validators: (value) {
                                          if (value!.isEmpty) {
                                            return "*please enter First name";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardTYPE: TextInputType.name,
                                        obscuretxt: false,
                                        showHide: false,
                                        readOnly: false,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      EmailFieldWidget(
                                        validators: (value) {
                                          if (value!.isEmpty) {
                                            return "*please enter Last Name";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardTYPE: TextInputType.name,
                                        controller: _lastNameController,
                                        icon: Icons.supervised_user_circle,
                                        hint: "Last Name",
                                        obscuretxt: false,
                                        showHide: false,
                                        readOnly: false,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      EmailFieldWidget(
                                        validators: (value) {
                                          if (value!.isEmpty) {
                                            return "*please enter DOB";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardTYPE: TextInputType.number,
                                        controller: _dobCintroller,
                                        icon: Icons.date_range,
                                        hint: "DOB",
                                        obscuretxt: false,
                                        showHide: false,
                                        readOnly: true,
                                        ontapofeditText: () async {
                                          await _selectDate(context);
                                          if (selectedDate != "null") {
                                            setState(() {
                                              _dobCintroller.text = selectd_date;
                                            });
                                          }

                                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data")));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      EmailFieldWidget(
                                        maxlength: 100,
                                        validators: (value) {
                                          if (value == null || value == "") {
                                            return '*please enter email address';
                                          } else {
                                            return EmailValidator.validate(value)
                                                ? null
                                                : "*Please enter a valid email";
                                          }
                                        },
                                        keyboardTYPE: TextInputType.emailAddress,
                                        controller: _emailController,
                                        icon: Icons.email,
                                        hint: "Email",
                                        obscuretxt: false,
                                        showHide: false,
                                        readOnly: false,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      EmailFieldWidget(
                                        validators: (value) {
                                          if (value!.isEmpty) {
                                            return "*please enter Password";
                                          } else if (!validateStructure(value)) {
                                            return "*password required minimum length of 8 character and 1 upper case, 1 lowercase, 1 numeric number, 1 special character, common allow character (! @ # \$ * ~)";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardTYPE: TextInputType.text,
                                        controller: _passwordController,
                                        icon: Icons.password,
                                        hint: "Password",
                                        obscuretxt: showHide,
                                        showHide: showHide,
                                        readOnly: false,
                                        ontapofsuffixicon: () {
                                          togglepsd();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                       DropDownField(selectedValue: gender,onselectGender: (value){
                                         setState(() {
                                           gender = value.toString();
                                         });
                                       },),
                                      // EmailFieldWidget(
                                      //   validators: (value) {
                                      //     return null;
                                      //   },
                                      //   keyboardTYPE: TextInputType.text,
                                      //   controller: _genderController,
                                      //   icon: Icons.transgender,
                                      //   hint: "Gender",
                                      //   obscuretxt: false,
                                      //   showHide: false,
                                      //   readOnly: false,
                                      //   ontapofeditText: (){
                                      //
                                      //   },
                                      // ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      EmailFieldWidget(
                                        validators: (value) {
                                          return null;
                                        },
                                        keyboardTYPE: TextInputType.text,
                                        controller: _locationCOntroller,
                                        icon: Icons.location_history,
                                        hint: "Location",
                                        obscuretxt: false,
                                        showHide: false,
                                        readOnly: false,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      EmailFieldWidget(
                                        validators: (value) {
                                          return null;
                                        },
                                        keyboardTYPE: TextInputType.text,
                                        controller: _cityController,
                                        icon: Icons.location_city,
                                        hint: "City",
                                        obscuretxt: false,
                                        showHide: false,
                                        readOnly: false,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      EmailFieldWidget(
                                        validators: (value) {
                                          return null;
                                        },
                                        keyboardTYPE: TextInputType.text,
                                        controller: _nationalityController,
                                        icon: Icons.map_outlined,
                                        hint: "Nationality",
                                        obscuretxt: false,
                                        showHide: false,
                                        readOnly: false,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          BtnWidget(
                            lable: "Sign up",
                            isLoading: isLoading,
                            ontap: () async {
                              if (_formKey.currentState?.validate() == true&& isLoading == false) {
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  var response = await API().SignUpAPI(
                                    _firstNameController.text,
                                    _lastNameController.text,
                                    _dobCintroller.text,
                                    _emailController.text,
                                    _passwordController.text,
                                    "$gender",
                                    _locationCOntroller.text,
                                    _cityController.text,
                                    _nationalityController.text,
                                  );
                                  if (response.toString().isNotEmpty) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                  int statusCode = response.statusCode;
                                  String responseBody = response.body;
                                  var res = jsonDecode(responseBody);
                                  if (statusCode == 200) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "${res['message']}");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (builder) => VerifyOtp(
                                          fromScreen: "Registration",
                                          email: _emailController.text,
                                        ),
                                      ),
                                    );
                                  } else if (statusCode == 400) {
                                    if (res['message'] ==
                                        "Email already exists") {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Email already exists , try different");
                                    }
                                  } else if (statusCode == 401) {
                                    Fluttertoast.showToast(
                                        msg: "Internal Server Error !!!");
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "${response.statusCode.toString()},$res['message']");
                                  }
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Fluttertoast.showToast(msg: e.toString());
                                }
                              }
                            },
                          ),
                        ],
                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: const [
                      //     Text(
                      //       "Don't have an account ? ",
                      //       style: TextStyle(
                      //         color: Colors.grey,
                      //         fontWeight: FontWeight.w300,
                      //         fontSize: 13,
                      //       ),
                      //     ),
                      //     Text(
                      //       "Sign up",
                      //       style: TextStyle(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.w400,
                      //           fontSize: 15),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
