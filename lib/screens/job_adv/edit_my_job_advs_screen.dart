// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:io';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/requests.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_select/smart_select.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

class EditMyJobAdvScreen extends StatefulWidget {
  static const routeName = '/edit-my-job-adv-screen';

  @override
  _EditMyJobAdvScreenState createState() => _EditMyJobAdvScreenState();
}

class _EditMyJobAdvScreenState extends State<EditMyJobAdvScreen> {
  String _jobAdImageUrl = '';
  String _jobAdId = "";
  final _jobAdTitle = TextEditingController();
  final _jobAdjobNumber = TextEditingController();
  final _jobAdPersonalNumber = TextEditingController();
  final _jobAdMail = TextEditingController();
  final _jobAdContent = TextEditingController();
  final _jobType = TextEditingController();
  final _city = TextEditingController();

  bool _isRendered = false;

  String _selectedItem = 'Diğer';
  String _diplomaItem = 'Hepsi';

  List<S2Choice<String>> items = [
    S2Choice<String>(value: 'Bilişim', title: 'Bilişim'),
    S2Choice<String>(value: 'Gıda', title: 'Gıda'),
    S2Choice<String>(value: 'Sağlık', title: 'Sağlık'),
    S2Choice<String>(value: 'Hizmet', title: 'Hizmet'),
    S2Choice<String>(value: 'Tekstil', title: 'Tekstil'),
    S2Choice<String>(value: 'Ticaret', title: 'Ticaret'),
    S2Choice<String>(value: 'Yapı', title: 'Yapı'),
    S2Choice<String>(value: 'Otomotiv', title: 'Otomotiv'),
    S2Choice<String>(value: 'Eğitim', title: 'Eğitim'),
    S2Choice<String>(value: 'Diğer', title: 'Diğer'),
  ];

  List<S2Choice<String>> diplomaItems = [
    S2Choice<String>(value: 'Hepsi', title: 'Hepsi'),
    S2Choice<String>(value: 'Lise', title: 'Lise'),
    S2Choice<String>(value: 'Önlisans - Öğrenci', title: 'Önlisans - Öğrenci'),
    S2Choice<String>(value: 'Önlisans - Mezun', title: 'Önlisans - Mezun'),
    S2Choice<String>(
        value: 'Üniversite - Öğrenci', title: 'Üniversite - Öğrenci'),
    S2Choice<String>(value: 'Üniversite - Mezun', title: 'Üniversite - Mezun'),
    S2Choice<String>(value: 'Yüksek Lisans', title: 'Yüksek Lisans'),
    S2Choice<String>(value: 'Doktora', title: 'Doktora'),
  ];

  Widget smartSelectKategori(String title, List options, String value) {
    return SmartSelect<String>.single(
        title: title,
        modalType: S2ModalType.popupDialog,
        value: value,
        choiceItems: options,
        onChange: (val) => setState(() => _selectedItem = val.value));
  }

  Widget smartSelectDiploma(String title, List options, String value) {
    return SmartSelect<String>.single(
        title: title,
        modalType: S2ModalType.popupDialog,
        value: value,
        choiceItems: options,
        onChange: (val) => setState(() => _diplomaItem = val.value));
  }

  File _image;

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
  //   _jobAdImageUrl = await taskSnapshot.ref.getDownloadURL();
  // }

  Future<void> getAdv(String _id, String token) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getUserJob',
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
      _jobAdTitle.text = body['jobAdTitle'];
      _jobAdjobNumber.text = body['jobAdCompanyNumber'];
      _jobAdPersonalNumber.text = body['jobAdPersonalNumber'];
      _jobAdMail.text = body['jobAdMail'];
      _jobAdContent.text = body['jobAdContent'];
      _selectedItem = body['jobAdType'];
      _diplomaItem = body['jobAdDiploma'];
      _jobType.text = body['jobType'];
      _city.text = body['city'];
      setState(() {
        _jobAdId = body['_id'];
      });
      setState(() {
        _jobAdImageUrl = body['jobAdImageUrl'];
      });
    } else {
      throw Exception('Failed to load album');
    }
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
            child: _showProgress
                ? Center(
                    heightFactor: 25,
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextFieldWidget(
                            keyboardType: TextInputType.text,
                            controller: _jobAdTitle,
                            labelText: 'İlan Başlığı',
                            height: 60,
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextFieldWidget(
                            keyboardType: TextInputType.number,
                            controller: _jobAdjobNumber,
                            labelText: 'Firma Telefon Numarası',
                            height: 60,
                            maxLength: 13,
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextFieldWidget(
                            keyboardType: TextInputType.number,
                            controller: _jobAdPersonalNumber,
                            labelText: 'Kişisel Telefon Numarası',
                            height: 60,
                            maxLength: 13,
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextFieldWidget(
                            keyboardType: TextInputType.emailAddress,
                            controller: _jobAdMail,
                            labelText: 'Mail Adresi',
                            height: 60,
                            maxLength: 30,
                          )),
                      smartSelectKategori('Kategori', items, _selectedItem),
                      smartSelectDiploma(
                          'Öğrenim Durumu', diplomaItems, _diplomaItem),
                      SizedBox(height: 10),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextFieldWidget(
                            controller: _jobAdContent,
                            labelText: 'İş İle İlgili Açıklama',
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
                            if (!validateEmail(_jobAdMail.text)) {
                              showToastError(
                                  "Doğru bir mail adresi girdiğinizden emin olun!");
                              return;
                            }
                            if (_jobAdTitle.text != '' &&
                                _jobAdContent.text != '') {
                              setState(() {
                                _showProgress = !_showProgress;
                              });
                              addJobAdvertisementRequest(
                                filter: '',
                                jobAdId: _jobAdId,
                                jobAdTitle: _jobAdTitle.text,
                                jobAdImageUrl: _jobAdImageUrl.toString(),
                                jobAdCompanyNumber: _jobAdjobNumber.text,
                                jobAdPersonalNumber: _jobAdPersonalNumber.text,
                                jobAdMail: _jobAdMail.text,
                                jobAdContent: _jobAdContent.text,
                                jobAdType: _selectedItem,
                                jobAdDiploma: _diplomaItem,
                                jobType: _jobType.text,
                                city: _city.text,
                              );
                              Future.delayed(const Duration(milliseconds: 2000),
                                  () {
                                setState(() {
                                  _showProgress = !_showProgress;
                                  Navigator.pop(context);
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
          )
        ],
      ),
    );
  }
}
