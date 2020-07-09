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

class AddNewJobAdvScreen extends StatefulWidget {
  static const routeName = "/add-new-job-advertisement";

  @override
  _AddNewJobAdvScreenState createState() => _AddNewJobAdvScreenState();
}

class _AddNewJobAdvScreenState extends State<AddNewJobAdvScreen> {
  String _jobAdImageUrl = '';
  final _jobAdTitle = TextEditingController();
  final _jobAdCompanyNumber = TextEditingController();
  final _jobAdPersonalNumber = TextEditingController();
  final _jobAdMail = TextEditingController();
  final _jobAdContent = TextEditingController();
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
    print(fileName);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    print(uploadTask);
    print(await firebaseStorageRef.getDownloadURL());
    _jobAdImageUrl = await firebaseStorageRef.getDownloadURL();
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yeni İş İlanı'),
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
                  controller: _jobAdTitle,
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
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      uploadPicture(context).then((value) {
                        addJobAdvertisementRequest(
                          filter: '',
                          jobAdTitle: _jobAdTitle.text,
                          jobAdImageUrl: _jobAdImageUrl.toString(),
                          jobAdCompanyNumber: _jobAdCompanyNumber.text,
                          jobAdPersonalNumber: _jobAdPersonalNumber.text,
                          jobAdMail: _jobAdMail.text,
                          jobAdContent: _jobAdContent.text,
                        );
                      });
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
