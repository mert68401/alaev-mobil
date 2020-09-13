import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/providers/auth.dart';
import 'package:alaev/screens/forgot_password_screen.dart';
import 'package:alaev/widgets/drawer_widget.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-page";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _password = TextEditingController();
  final _email = TextEditingController();
  bool _isLoading = false;

  Future<void> loginRequest(
      BuildContext context, String email, String password) async {
    if (password.length == 0 || email.length == 0) {
      Fluttertoast.showToast(
          msg: "Email adresinizi ve şifrenizi girmelisiniz.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return -1;
    }
    if (!validateEmail(email)) {
      Fluttertoast.showToast(
          msg: "Email adresinizi doğru yazdığınızdan emin olun.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return -1;
    }
    var passwordMd5 = md5.convert(utf8.encode(password));
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://10.0.2.2:2000/api/login',
      headers: headers,
      body: jsonEncode(
        <String, String>{"email": email, "password": passwordMd5.toString()},
      ),
    );

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> body = jsonDecode(response.body);
      await setToken(body['token']);
    } else {
      Fluttertoast.showToast(
          msg: "Email adresiniz veya şifreniz uyuşmamaktadır",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return -1;
    }
  }

  Widget _profileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _textFieldUsername(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      height: 60,
      child: TextField(
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 14,
        ),
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 10),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: 'Email Adresi',
          hintStyle: TextStyle(
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _textFieldPassword(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      height: 60,
      child: TextField(
        obscureText: true,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 14,
        ),
        controller: _password,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 10),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
          labelText: 'Şifre',
          hintStyle: TextStyle(
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
      child: Container(
        width: double.infinity,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: Text("Giriş yap"),
          onPressed: () {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
            Provider.of<Auth>(context, listen: false)
                .login(_email.text, _password.text)
                .then((value) {
              if (value) {
                Future.delayed(const Duration(milliseconds: 1500), () {
                  showToastSuccess('Başarı ile Giriş Yapıldı!');
                  setState(() {
                    _isLoading = false;
                    Navigator.pop(context);
                  });
                });
              }
            });
            Future.delayed(const Duration(milliseconds: 1500), () {
              setState(() {
                _isLoading = false;
              });
            });
          },
          color: Colors.green,
        ),
      ),
    );
  }

  void _pushRegisterScreen() {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
    return;
  }

  void _pushForgotPasswordScreen() {
    Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
    return;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              "./assets/images/alaevLogoClean.png",
              scale: 11,
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: _isLoading == true
                ? Center(
                    heightFactor: 25,
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.top,
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: screenSize.height * 0.1),
                          _profileImage(),
                          SizedBox(height: 20.0),
                          Column(
                            children: <Widget>[
                              SizedBox(height: 15.0),
                              _textFieldUsername(context),
                              SizedBox(height: 5.0),
                              _textFieldPassword(context),
                              SizedBox(height: 5.0),
                              _buildButtons(context),
                              SizedBox(height: 5.0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Hesabınız yok mu? "),
                              GestureDetector(
                                onTap: _pushRegisterScreen,
                                child: Text(
                                  "Kayıt ol.",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: _pushForgotPasswordScreen,
                                child: Text(
                                  "Şifremi Unuttum",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
