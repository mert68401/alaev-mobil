import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cv_screen.dart';
import 'package:http/http.dart' as http;
import '../functions/requests.dart';

class ProfileWrapper extends StatefulWidget {
  static const routeName = "/profile-page";

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfileWrapper>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();

  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();

    Future<void> getUserData() async {
      getToken().then((value) async {
        print(value);
        Map<String, String> headers = {"Content-type": "application/json"};

        final response = await http.post(
          'http://' + ServerIP().other + ':2000/api/getUserData',
          headers: headers,
          body: jsonEncode(
            <String, String>{"token": value,
            },
          ),
        );

        if (response.statusCode == 200) {
          userData = json.decode(response.body);
          _emailController.text = userData['email']['str'];
          print(userData);
          _fullNameController.text = userData['fullName'];
          _phoneController.text = userData['personalNumber'];
        } else if (response.statusCode == 401) {
          showToastError(jsonDecode(response.body)['message'].toString());
        }
      });
    }

    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).logout();
                })
          ],
          title: Text('Profil'),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 150,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[],
                    ),
                  ),
                  Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Ad Soyad',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  _status ? _getEditIcon() : Container(),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: _fullNameController,
                                      decoration: const InputDecoration(
                                        hintText: "Ad ve Soyad Giriniz",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Flexible(
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                          hintText: "Email Giriniz"),
                                      enabled: false,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Telefon',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                        hintText: "Telefon Numarınızı Giriniz"),
                                    enabled: !_status,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          !_status
                              ? _getActionButtons()
                              : Container(
                                  child: _cvButton(),
                                  padding: EdgeInsets.only(right: 65),
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _cvButton() {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 15, right: 50),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 100.0),
              child: Container(
                  child: RaisedButton(
                child: Text("CV Ekle/Düzenle"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushNamed(CvScreen.routeName);
                    return;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getActionButtons() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Kaydet"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                    updateUserInfo(
                        fullName: _fullNameController.text,
                        email: _emailController.text,
                        personalNumber: _phoneController.text);
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("İptal Et"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Theme.of(context).accentColor,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
