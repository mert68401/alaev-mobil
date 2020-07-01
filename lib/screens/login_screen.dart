import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/screens/home_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      'http://10.0.2.2:2000/api/login',
      headers: headers,
      body: jsonEncode(
        <String, String>{"email": email, "password": passwordMd5.toString()},
      ),
    );
    setState(() {
      _isLoading = false;
    });

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
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 10),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Kullanıcı adı',
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
          hintText: 'Şifre',
          hintStyle: TextStyle(
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: _isLoading
                      ? () => print("asdasd")
                      : () => loginRequest(
                          context, _email.text, _password.text), // ----
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.green,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: _isLoading
                            ? Text(
                                "Giriş yapılıyor..",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            : Text(
                                "Giriş Yap",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              //SizedBox(width: 10.0),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            child: InkWell(
              onTap: () {
                print("tapped" + DateTime.now().toString());
              },
              child: Text(
                "Şifremi Unuttum",
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pushNamedPage() {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
    return;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş'),
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
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
                          onTap: _pushNamedPage,
                          child: Text(
                            "Kayıt ol.",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    )
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
