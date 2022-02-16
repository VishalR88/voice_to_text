import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_to_text/Pages/Audio_Record_screen.dart';
import 'package:voice_to_text/Pages/login_page.dart';

class AuthClass {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> creaateuserwithemailandpwd(BuildContext context,String email,String password) async {
    try {
      UserCredential ruserCredential = await auth.createUserWithEmailAndPassword(email: email, password: password).whenComplete(() {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:  Text("Successfully registered")));
      });
      if(ruserCredential != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => LogInPage()),
                (route) => false);
      }

    }
    catch (e) {
      print(e);
      if(e.toString() == "[firebase_auth/invalid-email] The email address is badly formatted."){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The email address is badly formatted, please enter valid email address.")));
      }
      else if (e.toString()=="[firebase_auth/email-already-in-use] The email address is already in use by another account."){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("The email address is already in use by another account.")));
      }
      else{
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }

    }
  }

  // Future<void> signinwithemailandpwd(BuildContext context,String email,String password) async {
  //   try {
  //     UserCredential ruserCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
  //     if(ruserCredential.user!.uid != "" || ruserCredential.user!.uid != null){
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content:  Text("Login Success")));
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (builder) => AudioRecoedScreen()),
  //               (route) => false);
  //     }
  //     else{
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content:  Text("Email Passwors doesn't match.")));
  //     }
  //
  //
  //   } catch (e) {
  //     print(e);
  //     // ScaffoldMessenger.of(context).clearSnackBars();
  //     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  //
  //   }
  // }


  Future<void> googleSignin(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          UserCredential userCredential =
          await auth.signInWithCredential(credential);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', '${userCredential.user!.email}');

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => const AudioRecoedScreen()),
                  (route) => false);
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            duration: const Duration(milliseconds: 3000),
          ));
        }
      } else {
        print("google acc is null");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (e) {
      print('$e + Error while signing out');
    }
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
      await auth.signInWithCredential(credential);
      if(userCredential!=null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const AudioRecoedScreen()),
                (route) => false);
      }
    }
    catch (e) {
      if(e.toString() == "[firebase_auth/invalid-verification-code] The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user."){
        showSnackbar(context, "You entered wrong OTP, please enter valid verification code");
      }

    }
  }

  void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }




}