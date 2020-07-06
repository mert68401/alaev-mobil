// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:alaev/functions/requests.dart';
import 'package:alaev/widgets/icon_widget.dart';
import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

class AddNewCompanyAdvScreen extends StatefulWidget {
  static const routeName = "/add-new-company-advertisement";

  @override
  _AddNewCompanyAdvScreenState createState() => _AddNewCompanyAdvScreenState();
}

class _AddNewCompanyAdvScreenState extends State<AddNewCompanyAdvScreen> {
  final String _companyAdImageUrl = '';
  @required
  final _companyAdTitle = TextEditingController();
  @required
  final _companyAdCompanyNumber = TextEditingController();
  final _companyAdPersonalNumber = TextEditingController();
  final _companyAdMail = TextEditingController();
  @required
  final _companyAdContent = TextEditingController();

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
                IconWidget(
                    height: 65, width: 65, paddingTop: 30, paddingRight: 60),
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
                      addCompanyAdvertisementRequest(
                        filter: '',
                        companyAdTitle: _companyAdTitle.text,
                        companyAdImageUrl: _companyAdImageUrl.toString(),
                        companyAdCompanyNumber: _companyAdCompanyNumber.text,
                        companyAdPersonalNumber: _companyAdPersonalNumber.text,
                        companyAdMail: _companyAdMail.text,
                        companyAdContent: _companyAdContent.text,
                      );
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
  // File _image;

  // @override
  // Widget build(BuildContext context) {
  //   Future getImage() async {
  //     var image = await ImagePicker.pickImage(source: ImageSource.gallery);

  //     setState(() {
  //       _image = image;
  //       print(_image);
  //     });
  //   }

  //   Future uploadPicture(BuildContext ctx) async {
  //     String fileName = basename(_image.path);
  //     StorageReference firebaseStorageRef =
  //         FirebaseStorage.instance.ref().child(fileName);
  //     StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
  //     print(uploadTask);
  //     print(firebaseStorageRef);

  //     StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  //   }

  // return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Yeni İlan Ekle"),
  //     ),
  //     body: Column(
  //       children: <Widget>[
  //         _image == null
  //             ? Text("boş")
  //             : Image.file(
  //                 _image,
  //                 width: 500,
  //                 height: 500,
  //               ),
  //         IconButton(icon: Icon(Icons.add_a_photo), onPressed: getImage),
  //         IconButton(
  //             icon: Icon(Icons.file_upload),
  //             onPressed: () => uploadPicture(context)),
  //       ],
  //     ));
  //}
}
