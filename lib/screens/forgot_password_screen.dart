import 'dart:convert';

import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = '/forgotPassword';

  final email = TextEditingController();

  Future<void> forgotPasswordRequest(BuildContext context, String email) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  final response = await http.post(
    'http://10.0.2.2:2000/api/login',
    headers: headers,
    body: jsonEncode(
        <String, String>{"email": email}
      ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: const Text(
                    'Şifrenizi mi Unuttunuz?',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height: 150),
                Container(
                  child: TextFieldWidget(
                    controller: email,
                    labelText: 'E-mail',
                  ),
                ),
                SizedBox(height: 60),
                Container(
                    margin: EdgeInsets.only(left: 200),
                    width: MediaQuery.of(context).devicePixelRatio * 50,
                    child: RaisedButton(
                      child: const Text("Gönder"),
                      textColor: Colors.white,
                      color: Colors.green,
                      onPressed: () {print(email);},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
