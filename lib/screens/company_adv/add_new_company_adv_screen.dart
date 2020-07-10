// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ffi';
import 'dart:io';

import 'package:alaev/functions/requests.dart';
import 'package:alaev/widgets/textfield_default.dart';
import 'package:alaev/wrappers/profile_wrapper.dart';
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
    _companyAdImageUrl = await taskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni Firma İlanı'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
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
                  controller: _companyAdTitle,
                  labelText: 'İlan Başlığı',
                  height: 60,
                )),
                Container(
                    child: TextFieldWidget(
                  keyboardType: TextInputType.number,
                  controller: _companyAdCompanyNumber,
                  labelText: 'Firma Telefon Numarası',
                  height: 60,
                  maxLength: 13,
                )),
                Container(
                    child: TextFieldWidget(
                  keyboardType: TextInputType.number,
                  controller: _companyAdPersonalNumber,
                  labelText: 'Kişisel Telefon Numarası',
                  height: 60,
                  maxLength: 13,
                )),
                Container(
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
                      if (_image != null) {
                        uploadPicture(context).then((value) {
                          addCompanyAdvertisementRequest(
                            filter: '',
                            companyAdTitle: _companyAdTitle.text,
                            companyAdImageUrl: _companyAdImageUrl.toString(),
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
                          companyAdImageUrl: _companyAdImageUrl.toString(),
                          companyAdCompanyNumber: _companyAdCompanyNumber.text,
                          companyAdPersonalNumber:
                              _companyAdPersonalNumber.text,
                          companyAdMail: _companyAdMail.text,
                          companyAdContent: _companyAdContent.text,
                        );
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
