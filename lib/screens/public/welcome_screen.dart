import 'package:Pub/screens/public/login_screen.dart';
import 'package:Pub/screens/public/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoginPage = false;

  void _changePage(bool flag) {
    setState(() {
      isLoginPage = flag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
          child: isLoginPage
              ? LoginScreen(
                  stateChange: _changePage,
                )
              : RegisterScreen(
                  stateChange: _changePage,
                ),
        ),
    );
  }
}