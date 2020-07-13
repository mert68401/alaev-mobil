import 'package:alaev/functions/functions.dart';
import 'package:alaev/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register-page';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  String _dropDownVal = "Varsayılan";

  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt'),
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 60, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 60, bottom: 5),
                        margin: EdgeInsets.only(top: 30),
                        child: Text(
                          'Ad Soyad',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Container(
                        width: 300,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        height: 60,
                        child: TextField(
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          controller:
                              _fullNameController, //--------------------------------
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 60, bottom: 5),
                        child: Text(
                          'Kullanıcı Tipi',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Container(
                        width: 300,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        height: 60,
                        child: DropdownButton(
                          value: 1,
                          items: [
                            DropdownMenuItem(
                              child: Text("_dropDownVal"),
                            ),
                            DropdownMenuItem(
                              child: Text("İş Veren"),
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              _dropDownVal = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 60, bottom: 5),
                        margin: EdgeInsets.only(top: 1),
                        child: Text(
                          'Email',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Container(
                        width: 300,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        height: 60,
                        child: TextField(
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          controller:
                              _emailController, //--------------------------------
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 60, bottom: 5),
                        margin: EdgeInsets.only(top: 1),
                        child: Text(
                          'Şifre',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Container(
                        width: 300,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        height: 60,
                        child: TextField(
                          obscureText: true,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          controller:
                              _passwordController, //--------------------------------
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 60, bottom: 5),
                        margin: EdgeInsets.only(top: 1),
                        child: Text(
                          'Şifre Tekrar',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Container(
                        width: 300,
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        height: 60,
                        child: TextField(
                          obscureText: true,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          controller:
                              _password2Controller, //--------------------------------
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40, left: 40, right: 40),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_passwordController.text ==
                                _password2Controller.text) {
                              Provider.of<Auth>(context, listen: false).signup(
                                  _fullNameController.text,
                                  _emailController.text,
                                  _passwordController.text);
                            } else {
                              showToastError("Şifreleriniz eşleşmemektedir!");
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          }, // ----
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: Colors.green,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Kayıt Ol",
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
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
