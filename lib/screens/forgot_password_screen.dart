import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';

import '../functions/requests.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = '/forgotPassword';

  final email = TextEditingController();

  

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
                      onPressed: () {
                        forgotPasswordRequest(email: email.text);
                      },
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
