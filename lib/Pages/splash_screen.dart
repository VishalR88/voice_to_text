import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Audio_Record_screen.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigatetoDashBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SpinKitSpinningLines(
            color: Colors.white,
            size: 100.00,
          ),
          Text(
            "Welcome!!!",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w300, fontSize: 30),
          )
        ],
      ),
    );
  }

  Future<void> navigatetoDashBoard() async {
    final prefs = await SharedPreferences.getInstance();

    final key = prefs.getString('email');
    if(key!=null && key!=""){
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const AudioRecoedScreen()),
                (route) => false);
      });
    }else{
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => LogInPage()),
                (route) => false);
      });
    }


  }
}
