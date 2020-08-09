// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:io';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/requests.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/widgets/textfield_default.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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
  bool _isRendered = false;

  String _selectedItem = 'Diğer';
  final List<String> items = <String>[
    'Bilişim',
    'Gıda',
    'Sağlık',
    'Hizmet',
    'Tekstil',
    'Ticaret',
    'Yapı',
    'Otomotiv',
    'Eğitim',
    'Diğer'
  ];
  String _diplomaItem = 'Hepsi';
  final List<String> diplomaItems = <String>[
    'Hepsi',
    'Lise',
    'Önlisans - Öğrenci',
    'Önlisans - Mezun',
    'Üniversite - Öğrenci',
    'Üniversite - Mezun',
    'Yüksek Lisans',
    'Doktora'
  ];

  File _image;

  bool _showProgress = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future uploadPicture(BuildContext ctx) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    _jobAdImageUrl = await taskSnapshot.ref.getDownloadURL();
  }

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
        title: Text('İş İlanını Düzenle'),
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
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 150,
                            width: double.infinity,
                            child: _image == null
                                ? _jobAdImageUrl == "" || _jobAdImageUrl == null
                                    ? Image.network(
                                        "https://www.9minecraft.net/wp-content/plugins/accelerated-mobile-pages/images/SD-default-image.png",
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        _jobAdImageUrl,
                                        fit: BoxFit.cover,
                                      )
                                : Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
                            child: FloatingActionButton(
                              onPressed: () => getImage(),
                              elevation: 10,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.add_a_photo),
                            ),
                          )
                        ],
                      ),
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
                      Row(
                        children: <Widget>[
                          Text('İlan Tipi : '),
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
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Text('Diploma : '),
                          Container(
                            child: DropdownButton<String>(
                              isDense: true,
                              icon: Icon(Icons.arrow_drop_down),
                              value: _diplomaItem,
                              onChanged: (String diplomaString) => setState(() {
                                _diplomaItem = diplomaString;
                              }),
                              selectedItemBuilder: (BuildContext context) {
                                return diplomaItems
                                    .map<Widget>((String diplomaItem) {
                                  return Text(diplomaItem);
                                }).toList();
                              },
                              items: diplomaItems.map((String diplomaItem) {
                                return DropdownMenuItem<String>(
                                  child: Text('$diplomaItem'),
                                  value: diplomaItem,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),  
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
                            if (_jobAdTitle.text != '' &&
                                _jobAdjobNumber.text != '' &&
                                _jobAdContent.text != '') {
                              setState(() {
                                _showProgress = !_showProgress;
                              });
                              if (_image != null) {
                                uploadPicture(context).then((value) {
                                  addJobAdvertisementRequest(
                                      filter: '',
                                      jobAdId: _jobAdId,
                                      jobAdTitle: _jobAdTitle.text,
                                      jobAdImageUrl: _jobAdImageUrl.toString(),
                                      jobAdCompanyNumber: _jobAdjobNumber.text,
                                      jobAdPersonalNumber:
                                          _jobAdPersonalNumber.text,
                                      jobAdMail: _jobAdMail.text,
                                      jobAdContent: _jobAdContent.text,
                                      jobAdType: _selectedItem,
                                      jobAdDiploma: _diplomaItem);
                                });
                              } else {
                                addJobAdvertisementRequest(
                                    filter: '',
                                    jobAdId: _jobAdId,
                                    jobAdTitle: _jobAdTitle.text,
                                    jobAdImageUrl: _jobAdImageUrl.toString(),
                                    jobAdCompanyNumber: _jobAdjobNumber.text,
                                    jobAdPersonalNumber:
                                        _jobAdPersonalNumber.text,
                                    jobAdMail: _jobAdMail.text,
                                    jobAdContent: _jobAdContent.text,
                                    jobAdType: _selectedItem,
                                    jobAdDiploma: _diplomaItem);
                              }
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
