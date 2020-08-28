// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';

import 'package:alaev/functions/requests.dart';
import 'package:alaev/widgets/textfield_default.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

class AddNewCompanyAdvScreen extends StatefulWidget {
  static const routeName = "/add-new-company-advertisement";

  @override
  _AddNewCompanyAdvScreenState createState() => _AddNewCompanyAdvScreenState();
}

class _AddNewCompanyAdvScreenState extends State<AddNewCompanyAdvScreen> {
  String _companyAdImageUrl = '';
  final _companyAdTitle = TextEditingController();
  final _companyAdCompanyNumber = TextEditingController();
  final _companyAdPersonalNumber = TextEditingController();
  final _companyAdMail = TextEditingController();
  final _companyAdContent = TextEditingController();
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
    _companyAdImageUrl = await taskSnapshot.ref.getDownloadURL();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              height: 150,
                              width: double.infinity,
                              child: _image == null
                                  ? Image.asset(
                                      "assets/images/empty.png",
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: FloatingActionButton(
                                onPressed: () => getImage(),
                                elevation: 10,
                                backgroundColor: Colors.green,
                                child: Icon(Icons.add_a_photo),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          controller: _companyAdTitle,
                          labelText: 'İlan Başlığı',
                          height: 60,
                        )),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.number,
                          controller: _companyAdCompanyNumber,
                          labelText: 'Firma Telefon Numarası',
                          height: 60,
                          maxLength: 13,
                        )),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.number,
                          controller: _companyAdPersonalNumber,
                          labelText: 'Kişisel Telefon Numarası',
                          height: 60,
                          maxLength: 13,
                        )),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.emailAddress,
                          controller: _companyAdMail,
                          labelText: 'Mail Adresi',
                          height: 60,
                          maxLength: 30,
                        )),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          controller: _companyAdContent,
                          labelText: 'İş İle İlgili Açıklama',
                          height: 200,
                          maxLines: 8,
                          maxLength: 500,
                          counterText: null,
                        )),
                        Container(
                          child: RaisedButton(
                            child: Text("İlanı Kaydet"),
                            textColor: Colors.white,
                            color: Colors.green,
                            onPressed: () {
                              if (_companyAdTitle.text != '' &&
                                  _companyAdCompanyNumber.text != '' &&
                                  _companyAdContent.text != '') {
                                setState(() {
                                  _showProgress = !_showProgress;
                                });
                                if (_image != null) {
                                  uploadPicture(context).then((value) {
                                    addCompanyAdvertisementRequest(
                                      filter: '',
                                      companyAdTitle: _companyAdTitle.text,
                                      companyAdImageUrl:
                                          _companyAdImageUrl.toString(),
                                      companyAdCompanyNumber:
                                          _companyAdCompanyNumber.text,
                                      companyAdPersonalNumber:
                                          _companyAdPersonalNumber.text,
                                      companyAdMail: _companyAdMail.text,
                                      companyAdContent: _companyAdContent.text,
                                    );
                                  });
                                } else {
                                  addCompanyAdvertisementRequest(
                                    filter: '',
                                    companyAdTitle: _companyAdTitle.text,
                                    companyAdImageUrl:
                                        _companyAdImageUrl.toString(),
                                    companyAdCompanyNumber:
                                        _companyAdCompanyNumber.text,
                                    companyAdPersonalNumber:
                                        _companyAdPersonalNumber.text,
                                    companyAdMail: _companyAdMail.text,
                                    companyAdContent: _companyAdContent.text,
                                  );
                                }
                                Future.delayed(
                                    const Duration(milliseconds: 2000), () {
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
            ),
          )
        ],
      ),
    );
  }
}
