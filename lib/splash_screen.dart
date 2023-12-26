import 'package:flutter/material.dart';

import 'package:login_project_test1/authentication/pages/authpage.dart';
import 'dark_mode.dart'; // Assuming you already have this file.

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initSplashScreen();
  }

  // Simulate a delay for the splash screen
  Future<void> _initSplashScreen() async {
    await Future.delayed(Duration(
        seconds:
            5)); // You can adjust the delay duration as per your preference.
    _navigateToHomePage();
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AuthPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
