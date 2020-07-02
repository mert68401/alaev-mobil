import 'package:alaev/providers/auth.dart';
import 'package:flutter/material.dart';
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
                      ? () => null
                      : () {
                          setState(() {
                            _isLoading = true;
                          });
                          Provider.of<Auth>(context, listen: false)
                              .login(_email.text, _password.text)
                              .then((value) => Navigator.pop(context));
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
