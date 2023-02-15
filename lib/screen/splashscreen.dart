import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_complete_guide/screen/login.dart';

class SPlashScreen extends StatefulWidget {
  const SPlashScreen({Key? key}) : super(key: key);
  @override
  _SPlashScreenState createState() => _SPlashScreenState();
}

class _SPlashScreenState extends State<SPlashScreen> {
  @override
  void initState() {
    super.initState();

    // checkLogin();
    const delay = Duration(seconds: 1);
    Future.delayed(delay, () => _loadFromPrefs());
  }

  _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final is_login = prefs.getBool('is_login');
    String? email = prefs.getString('email');
    if (is_login == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
