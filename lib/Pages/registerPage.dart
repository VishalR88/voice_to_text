import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_to_text/Widget/btn_widget.dart';
import 'package:voice_to_text/Widget/email_textField_widget.dart';

import '../firebase_service.dart';
import 'Audio_Record_screen.dart';

class RegisterPage extends StatefulWidget {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                          "SignUp to continue",
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
                                        controller: _firstNameController,icon: Icons.supervised_user_circle,hint: "First name",
                                    validators: (value) {
                                      if(value!.isEmpty){
                                        return "please enter First name";
                                      }else{
                                        return null;
                                      }
                                    } ,

                                    ),
                                    const SizedBox(height: 12,),
                                    EmailFieldWidget(validators: (value) {
                                      if(value!.isEmpty){
                                        return "please enter Last Name";
                                      }else{
                                        return "";
                                      }
                                    } ,
                                        controller: _lastNameController,icon: Icons.supervised_user_circle,hint: "Last Name",),

                                    const SizedBox(height: 12,),
                                    EmailFieldWidget(validators: (value) {
                                      if(value!.isEmpty){
                                        return "please enter DOB";
                                      }else{
                                        return "";
                                      }
                                    } ,
                                        controller: _dobCintroller,icon: Icons.date_range,hint: "DOB",),

                                    const SizedBox(height: 12,),
                                    EmailFieldWidget(validators: (value) {
                                      if(value!.isEmpty){
                                        return "please enter email id";
                                      }else{
                                        return "";
                                      }
                                    } ,
                                        controller: _emailController,icon: Icons.email,hint: "Email",),

                                    const SizedBox(height: 12,),
                                    EmailFieldWidget(validators: (value) {
                                      if(value!.isEmpty){
                                        return "please enter Password";
                                      }else{
                                        return "";
                                      }
                                    } ,
                                        controller: _passwordController,icon: Icons.password,hint: "Password",),

                                    const SizedBox(height: 12,),
                                    EmailFieldWidget(validators: (value) {
                                     return null;
                                    } ,
                                        controller: _genderController,icon: Icons.transgender,hint: "Gender",),

                                    const SizedBox(height: 12,),
                                    EmailFieldWidget(validators: (value) {
                                     return null;
                                    } ,
                                        controller: _locationCOntroller,icon: Icons.location_history,hint: "Location",),

                                    const SizedBox(height: 12,),
                                    EmailFieldWidget(validators: (value) {
                                     return null;
                                    } ,
                                        controller: _cityController, icon: Icons.location_city,hint: "City",),
                                    const SizedBox(height: 12,),
                                    EmailFieldWidget(validators: (value) {
                                     return null;
                                    } ,
                                      controller: _nationalityController, icon: Icons.map_outlined,hint: "Nationality",),


                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BtnWidget(
                          lable: "Login",
                          ontap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => AudioRecoedScreen()),
                                    (route) => false);
                         /*   if (_formKey.currentState?.validate()==true) {
                              fconnection
                                  .saveToFirebase(_emailController.text)
                                  .whenComplete(() async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    'email', '${_emailController.text}');
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => AudioRecoedScreen()),
                                    (route) => false);
                              });
                            }*/
                          },
                        ),
                      ],
                    ),
                    Row(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
