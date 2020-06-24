import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login-page";

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
    final _username = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      height: 60,
      child: TextField(
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 14,
        ),
        controller: _username,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Kullanıcı adı',
          hintStyle: TextStyle(
            color: Colors.blueGrey,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).accentColor),
          ),
        ),
      ),
    );
  }

  Widget _textFieldPassword(context) {
    final _password = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      height: 60,
      child: TextField(
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 14,
        ),
        controller: _password,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Şifre',
          hintStyle: TextStyle(
            color: Colors.blueGrey,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).accentColor),
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
                  onTap: () => print("login"), // ----
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.green,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
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
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () => print("forgot"), // ----
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    margin: EdgeInsets.only(
                      left: 250,
                      top: 10,
                    ),
                    elevation: 0,
                    child: Text(
                      "Şifremi Unuttum",
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 50),
                  _profileImage(),
                  SizedBox(height: 20.0),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Theme.of(context).primaryColor,
                    margin: EdgeInsets.all(20),
                    elevation: 5,
                    borderOnForeground: false,
                    child: Column(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
