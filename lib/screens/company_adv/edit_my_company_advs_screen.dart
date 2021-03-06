// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/requests.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

class EditMyCompanyAdvScreen extends StatefulWidget {
  static const routeName = '/edit-my-company-adv-screen';

  @override
  _EditMyCompanyAdvScreenState createState() => _EditMyCompanyAdvScreenState();
}

class _EditMyCompanyAdvScreenState extends State<EditMyCompanyAdvScreen> {
  String _companyAdImageUrl = '';
  String _companyAdId = "";
  final _companyAdTitle = TextEditingController();
  final _companyName = TextEditingController();
  final _companyAdCompanyNumber = TextEditingController();
  final _companyAdPersonalNumber = TextEditingController();
  final _companyAdMail = TextEditingController();
  final _companyAdContent = TextEditingController();
  bool _isRendered = false;
  // File _image;

  bool _showProgress = false;

  // Future getImage() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     _image = image;
  //   });
  // }

  // Future uploadPicture(BuildContext ctx) async {
  //   String fileName = basename(_image.path);
  //   StorageReference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child(fileName);
  //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
  //   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  //   _companyAdImageUrl = await taskSnapshot.ref.getDownloadURL();
  // }

  Future<void> getAdv(String _id, String token) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getUserAdv',
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{
          "_id": _id,
          "token": token,
          "filter": {},
          "params": {
            "sort": {"createdAt": -1}
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      _companyAdTitle.text = body['companyAdTitle'];
      _companyName.text = body['companyName'];
      _companyAdCompanyNumber.text = body['companyAdCompanyNumber'];
      _companyAdPersonalNumber.text = body['companyAdPersonalNumber'];
      _companyAdMail.text = body['companyAdMail'];
      _companyAdContent.text = body['companyAdContent'];
      setState(() {
        _companyAdId = body['_id'];
      });
      setState(() {
        _companyAdImageUrl = body['companyAdImageUrl'];
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (_isRendered == false) {
      getToken().then((token) {
        getAdv(arguments['_id'], token);
      });
      _isRendered = true;
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Bilgileri Eksiksiz Giriniz!'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: _showProgress
                  ? Center(
                      heightFactor: 25,
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFieldWidget(
                              controller: _companyAdTitle,
                              labelText: 'İlan Başlığı',
                              height: 60,
                            )),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          controller: _companyName,
                          labelText: 'Firma İsmi',
                          height: 60,
                        )),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFieldWidget(
                              keyboardType: TextInputType.number,
                              controller: _companyAdCompanyNumber,
                              labelText: 'Firma Telefon Numarası',
                              height: 60,
                              maxLength: 13,
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFieldWidget(
                              keyboardType: TextInputType.number,
                              controller: _companyAdPersonalNumber,
                              labelText: 'Kişisel Telefon Numarası',
                              height: 60,
                              maxLength: 13,
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFieldWidget(
                              keyboardType: TextInputType.emailAddress,
                              controller: _companyAdMail,
                              labelText: 'Mail Adresi',
                              height: 60,
                              maxLength: 30,
                            )),
                        Container(
                            child: TextFieldWidget(
                          controller: _companyAdContent,
                          labelText: 'İlan İle İlgili Açıklama',
                          height: 200,
                          maxLines: 8,
                          maxLength: 500,
                          counterText: null,
                        )),
                        Container(
                          child: RaisedButton(
                            child: Text("İlanı Kaydet"),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            textColor: Colors.white,
                            color: Colors.green,
                            onPressed: () {
                              if (!validateEmail(_companyAdMail.text)) {
                                showToastError(
                                    "Doğru bir mail adresi girdiğinizden emin olun!");
                                return;
                              }
                              if (_companyAdTitle.text != '' &&
                                  _companyAdCompanyNumber.text != '' &&
                                  _companyAdContent.text != '') {
                                setState(() {
                                  _showProgress = !_showProgress;
                                });
                                addCompanyAdvertisementRequest(
                                  filter: '',
                                  companyAdId: _companyAdId,
                                  companyAdTitle: _companyAdTitle.text,
                                  companyName: _companyName.text,
                                  companyAdImageUrl:
                                      _companyAdImageUrl.toString(),
                                  companyAdCompanyNumber:
                                      _companyAdCompanyNumber.text,
                                  companyAdPersonalNumber:
                                      _companyAdPersonalNumber.text,
                                  companyAdMail: _companyAdMail.text,
                                  companyAdContent: _companyAdContent.text,
                                );
                                Future.delayed(
                                    const Duration(milliseconds: 2000), () {
                                  setState(() {
                                    _showProgress = !_showProgress;
                                    Navigator.of(context).pop();
                                  });
                                });
                              } else {
                                _showMyDialog();
                              }
                            },
                          ),
                        )
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
