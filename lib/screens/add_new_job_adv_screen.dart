// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:alaev/functions/requests.dart';
import 'package:alaev/widgets/icon_widget.dart';
import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

class AddNewAdvScreen extends StatefulWidget {
  static const routeName = "/add-new-advertisement";

  @override
  _AddNewAdvScreenState createState() => _AddNewAdvScreenState();
}

class _AddNewAdvScreenState extends State<AddNewAdvScreen> {
  final String _adImageUrl = '';
  @required
  final _adTitle = TextEditingController();
  final _adCompanyNumber = TextEditingController();
  final _adPersonalNumber = TextEditingController();
  final _adMail = TextEditingController();
  String _adDiplomaSelectedItem = 'Üniversite';
  final _adContent = TextEditingController();

  final List<String> items = <String>[
    'Üniversite',
    'Üniversite(Mezun)',
    'Önlisans',
    'Önlisans(Mezun)',
    'Lise',
    'Lise(Mezun)',
  ];

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
                IconWidget(
                    height: 65, width: 65, paddingTop: 30, paddingRight: 60),
                Container(
                    child: TextFieldWidget(
                  controller: _adTitle,
                  labelText: 'İlan Başlığı',
                  height: 60,
                )),
                Container(
                    child: TextFieldWidget(
                  controller: _adCompanyNumber,
                  labelText: 'Firma Telefon Numarası',
                  height: 60,
                )),
                Container(
                    child: TextFieldWidget(
                  controller: _adPersonalNumber,
                  labelText: 'Kişisel Telefon Numarası',
                  height: 60,
                )),
                Container(
                    child: TextFieldWidget(
                  controller: _adMail,
                  labelText: 'Mail Adresi',
                  height: 60,
                )),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Eğitim Durumu : ',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: DropdownButton<String>(
                          value: _adDiplomaSelectedItem,
                          onChanged: (String string) => setState(() {
                            _adDiplomaSelectedItem = string;
                            print(_adDiplomaSelectedItem);
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
                      )
                    ],
                  ),
                ),
                Container(
                    child: TextFieldWidget(
                  controller: _adContent,
                  labelText: 'İş İle İlgili Açıklama',
                  height: 160,
                  maxLines: 6,
                  maxLength: 500,
                  counterText: null,
                )),
                Container(
                  child: RaisedButton(
                    child: Text("İlanı Kaydet"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      addAdvertisementRequest(
                          adTitle: _adTitle.text,
                          adImageUrl: _adImageUrl.toString(),
                          adCompanyNumber: _adCompanyNumber.text,
                          adPersonalNumber: _adPersonalNumber.text,
                          adMail: _adMail.text,
                          adDiplomaSelectedItem: _adDiplomaSelectedItem,
                          adContent: _adContent.text);
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
