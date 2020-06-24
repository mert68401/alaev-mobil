import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login-page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: Text("This login"),
      ),
      
    );
  }
}
