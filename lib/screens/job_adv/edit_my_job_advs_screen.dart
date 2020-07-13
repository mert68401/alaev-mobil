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

class EditMyJobAdvScreen extends StatefulWidget {
  static const routeName = '/edit-my-job-adv-screen';

  @override
  _EditMyJobAdvScreenState createState() => _EditMyJobAdvScreenState();
}

class _EditMyJobAdvScreenState extends State<EditMyJobAdvScreen> {
  String _jobAdImageUrl = '';
  final _jobAdTitle = TextEditingController();
  final _jobAdCompanyNumber = TextEditingController();
  final _jobAdPersonalNumber = TextEditingController();
  final _jobAdMail = TextEditingController();
  final _jobAdContent = TextEditingController();
  File _image;

  bool _showProgress = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print(_image);
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

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    void fetchUserData() async {
      setState(() {
        _jobAdImageUrl = arguments['imageUrl'].toString();
        _jobAdTitle.text = arguments['title'];
        _jobAdCompanyNumber.text = arguments['companyNumber'];
        _jobAdPersonalNumber.text = arguments['personalNumber'];
        _jobAdMail.text = arguments['email'];
        _jobAdContent.text = arguments['content'];
      });
    }

    fetchUserData();

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
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: _showProgress
                  ? Center(
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
                                  ? Image.network(
                                      "https://www.9minecraft.net/wp-content/plugins/accelerated-mobile-pages/images/SD-default-image.png",
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
                        Container(
                            child: TextFieldWidget(
                          controller: _jobAdTitle,
                          onChanged: (text) {
                            _jobAdTitle.text = text;
                          },
                          labelText: 'İlan Başlığı',
                          height: 60,
                        )),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.number,
                          controller: _jobAdCompanyNumber,
                          labelText: 'Firma Telefon Numarası',
                          height: 60,
                          maxLength: 13,
                        )),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.number,
                          controller: _jobAdPersonalNumber,
                          labelText: 'Kişisel Telefon Numarası',
                          height: 60,
                          maxLength: 13,
                        )),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.emailAddress,
                          controller: _jobAdMail,
                          labelText: 'Mail Adresi',
                          height: 60,
                          maxLength: 30,
                        )),
                        Container(
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
                                  _jobAdCompanyNumber.text != '' &&
                                  _jobAdContent.text != '') {
                                setState(() {
                                  _showProgress = !_showProgress;
                                });
                                if (_image != null) {
                                  uploadPicture(context).then((value) {
                                    addJobAdvertisementRequest(
                                      filter: '',
                                      jobAdTitle: _jobAdTitle.text,
                                      jobAdImageUrl: _jobAdImageUrl.toString(),
                                      jobAdCompanyNumber:
                                          _jobAdCompanyNumber.text,
                                      jobAdPersonalNumber:
                                          _jobAdPersonalNumber.text,
                                      jobAdMail: _jobAdMail.text,
                                      jobAdContent: _jobAdContent.text,
                                    );
                                  });
                                } else {
                                  addJobAdvertisementRequest(
                                    filter: '',
                                    jobAdTitle: _jobAdTitle.text,
                                    jobAdImageUrl: _jobAdImageUrl.toString(),
                                    jobAdCompanyNumber:
                                        _jobAdCompanyNumber.text,
                                    jobAdPersonalNumber:
                                        _jobAdPersonalNumber.text,
                                    jobAdMail: _jobAdMail.text,
                                    jobAdContent: _jobAdContent.text,
                                  );
                                }
                                Future.delayed(
                                    const Duration(milliseconds: 2000), () {
                                  setState(() {
                                    _showProgress = !_showProgress;
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
