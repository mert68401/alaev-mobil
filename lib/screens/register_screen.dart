import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register-page';

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
                          controller: null, //--------------------------------
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
                          controller: null, //--------------------------------
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
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          controller: null, //--------------------------------
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
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          controller: null, //--------------------------------
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
                          onTap: () => print("kayıt"), // ----
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
