import 'package:alaev/functions/functions.dart';
import 'package:alaev/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _graduateYearController = TextEditingController();

  String _selectedItem = 'Bireysel';

  final List<String> items = <String>[
    'Bireysel',
    'Kurumsal',
  ];

  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 60,
                        child: TextField(
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Ad Soyad',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 60,
                        child: TextField(
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 60,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          controller: _graduateYearController,
                          decoration: InputDecoration(
                            counterText: "",
                            labelText: 'Mezuniyet Yılı',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
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
                            labelText: 'Şifre',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
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
                            labelText: 'Şifre Tekrar',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 1),
                            child: Text('Hesap Tipi :'),
                          ),
                          SizedBox(width: 40),
                          Container(
                            child: DropdownButton<String>(
                              isDense: true,
                              icon: Icon(Icons.arrow_drop_down),
                              value: _selectedItem,
                              onChanged: (String string) => setState(() {
                                _selectedItem = string;
                              }),
                              selectedItemBuilder: (BuildContext context) {
                                return items.map<Widget>((String item) {
                                  return Text(item);
                                }).toList();
                              },
                              items: items.map((String item) {
                                return DropdownMenuItem<String>(
                                  child: Text('$item'),
                                  value: item,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 40, right: 40),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_fullNameController.text == '' ||
                                _emailController.text == '') {
                              showToastError("Bilgiler eksiksiz girilmelidir!");
                              return;
                            }
                            if (!validateEmail(_emailController.text)) {
                              showToastError(
                                  "Doğru bir mail adresi girdiğinizden emin olun!");
                            }
                            if (_passwordController.text.length < 5) {
                              showToastError(
                                  "Şifreniz en az 6 karakter olmalıdır");
                              return;
                            }
                            if (_passwordController.text ==
                                _password2Controller.text) {
                              Provider.of<Auth>(context, listen: false)
                                  .signup(
                                      _fullNameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                      _selectedItem)
                                  .then((value) {
                                if (value) {
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              showToastError("Şifreler eşleşmemektedir!");
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
