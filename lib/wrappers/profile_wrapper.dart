import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/providers/auth.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool _switchVal;
  bool _isLoading = false;
  bool _isFirma = false;
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyDiscountController = TextEditingController();
  final _companyAdressController = TextEditingController();
  final _jobController = TextEditingController();
  final _companyPhoneController = TextEditingController();

  final FocusNode myFocusNode = FocusNode();

  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();

    getUserRole().then((value) {
      if (value == "Kurumsal") {
        setState(() {
          _isFirma = true;
        });
      }
    });
    Future<void> getUserData() async {
      getToken().then((value) async {
        Map<String, String> headers = {"Content-type": "application/json"};

        final response = await http.post(
          'http://' + ServerIP().other + ':2000/api/getUserData',
          headers: headers,
          body: jsonEncode(
            <String, String>{
              "token": value,
            },
          ),
        );

        if (response.statusCode == 200) {
          userData = json.decode(response.body);
          print(userData['showPhone']);
          setState(() {
            _switchVal = userData['showPhone'];
          });
          _emailController.text = userData['email']['str'];
          _fullNameController.text = userData['fullName'];
          _phoneController.text = userData['phone'];
          _companyNameController.text = userData['companyName'];
          _companyDiscountController.text = userData['companyDiscount'];
          _companyAdressController.text = userData['companyAdress'];
          _jobController.text = userData['job'];
          _companyPhoneController.text = userData['companyPhone'];
        } else if (response.statusCode == 401) {
          showToastError(jsonDecode(response.body)['message'].toString());
        }
      });
    }

    getUserData();
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _drawerKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              }),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    Provider.of<Auth>(context, listen: false).logout();
                    showToastSuccess('Başarı ile Çıkış Yapıldı!');
                    setState(() {
                      _isLoading = false;
                    });
                  });
                })
          ],
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
        body: _isLoading
            ? Center(
                heightFactor: 25,
                child: CircularProgressIndicator(),
              )
            : Container(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
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
                                        _status
                                            ? Row(
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    margin: EdgeInsets.only(
                                                        right: 10, left: 10),
                                                    child: RaisedButton(
                                                      child: Row(
                                                        children: [
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .qrcode,
                                                            size: 15,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            "QR Kod Okuyucu",
                                                            style: TextStyle(),
                                                          ),
                                                        ],
                                                      ),
                                                      textColor: Colors.white,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      onPressed: () async {
                                                        var result =
                                                            await BarcodeScanner
                                                                .scan();
                                                        if (result.rawContent
                                                                .length >
                                                            0) {
                                                          getDiscountFromQr(result
                                                                  .rawContent)
                                                              .then((discount) {
                                                            if (discount
                                                                    .length >
                                                                0) {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Barcodun içeriği"),
                                                                    content: Text(
                                                                        discount
                                                                            .toString()),
                                                                    actions: <
                                                                        Widget>[
                                                                      FlatButton(
                                                                        child: Text(
                                                                            "Kapat"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Hatalı Barkod!"),
                                                                    content: Text(
                                                                        "Lütfen doğru barkodu okuttuğunuzdan emin olun."),
                                                                    actions: <
                                                                        Widget>[
                                                                      FlatButton(
                                                                        child: Text(
                                                                            "Kapat"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          });
                                                        }
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                    ),
                                                  ),
                                                  _getEditIcon(),
                                                ],
                                              )
                                            : Container(),
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
                                        left: 25.0, right: 25.0, top: 20.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                        left: 25.0, right: 25.0, top: 20.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  'Telefon',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Switch(
                                                  value: _switchVal != null
                                                      ? _switchVal
                                                      : false,
                                                  onChanged: (newVal) {
                                                    setState(() {
                                                      _switchVal = newVal;
                                                      updateShowPhone(
                                                          showPhone:
                                                              _switchVal);
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Telefon numaranızın görünürlüğü',
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                ),
                                              ],
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
                                              hintText:
                                                  "Telefon Numarınızı Giriniz"),
                                          enabled: !_status,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                !_isFirma
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 20.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Meslek',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ))
                                    : SizedBox(),
                                !_isFirma
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Flexible(
                                                child: TextField(
                                                    controller: _jobController,
                                                    enabled: false,
                                                    autofocus: !_status,
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                            hintText: null))),
                                          ],
                                        ))
                                    : SizedBox(),
                                _isFirma
                                    ? Column(
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 20.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        'Şirket İsmi',
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 2.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Flexible(
                                                  child: TextField(
                                                    controller:
                                                        _companyNameController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                "Şirket İsminizi Giriniz"),
                                                    enabled: !_status,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 20.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        'Şirket Adresi',
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Flexible(
                                                  child: TextField(
                                                    maxLength: 150,
                                                    maxLines: 2,
                                                    controller:
                                                        _companyAdressController,
                                                    enabled: !_status,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        'Şirket Numarası',
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                                top: 2.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Flexible(
                                                  child: TextField(
                                                    controller:
                                                        _companyPhoneController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                "Şirket İsminizi Giriniz"),
                                                    enabled: !_status,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                left: 25.0,
                                                right: 25.0,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        'İndirim Yüzdesi',
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 285.0,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Flexible(
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 2,
                                                    inputFormatters: [
                                                      WhitelistingTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    controller:
                                                        _companyDiscountController,
                                                    decoration:
                                                        const InputDecoration(
                                                            counterText: '',
                                                            hintText: "%0-99"),
                                                    enabled: !_status,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(height: 0),
                                !_status
                                    ? _getActionButtons()
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: _cvButton(),
                                            ),
                                          ),
                                        ],
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
    return _isFirma
        ? null
        : Container(
            margin: EdgeInsets.only(top: 25, left: 10, right: 10),
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
                      phone: _phoneController.text,
                      companyName: _companyNameController.text,
                      companyDiscount: _companyDiscountController.text,
                      companyAdress: _companyAdressController.text,
                      job: _jobController.text,
                      companyPhone: _companyPhoneController.text,
                    );
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
