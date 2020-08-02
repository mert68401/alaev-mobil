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

  String _selectedItem = 'Bilişim';
  String _diplomaItem = 'Hepsi';
  final List<String> items = <String>[
    'Bilişim',
    'Hizmet',
    'Gıda',
  ];
  final List<String> diplomaItems = <String>[
    'Hepsi',
    'Lise',
    'Üniversite',
    'Önlisans',
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
        title: Text('Yeni İş İlanı'),
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
                : Container(
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
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          controller: _jobAdTitle,
                          labelText: 'İlan Başlığı',
                          height: 60,
                        )),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.number,
                          controller: _jobAdCompanyNumber,
                          labelText: 'Firma Telefon Numarası',
                          height: 60,
                          maxLength: 13,
                        )),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.number,
                          controller: _jobAdPersonalNumber,
                          labelText: 'Kişisel Telefon Numarası',
                          height: 60,
                          maxLength: 13,
                        )),
                        SizedBox(height: 10),
                        Container(
                            child: TextFieldWidget(
                          keyboardType: TextInputType.emailAddress,
                          controller: _jobAdMail,
                          labelText: 'Mail Adresi',
                          height: 60,
                          maxLength: 30,
                        )),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('İlan Tipi :'),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    value: _selectedItem,
                                    onChanged: (String string) => setState(() {
                                      _selectedItem = string;
                                    }),
                                    selectedItemBuilder:
                                        (BuildContext context) {
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
                                Text('Diploma : '),
                                Container(
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    icon: Icon(Icons.arrow_drop_down),
                                    value: _diplomaItem,
                                    onChanged: (String diplomaString) =>
                                        setState(() {
                                      _diplomaItem = diplomaString;
                                    }),
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return diplomaItems
                                          .map<Widget>((String diplomaItem) {
                                        return Text(diplomaItem);
                                      }).toList();
                                    },
                                    items:
                                        diplomaItems.map((String diplomaItem) {
                                      return DropdownMenuItem<String>(
                                        child: Text('$diplomaItem'),
                                        value: diplomaItem,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
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
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            textColor: Colors.white,
                            color: Colors.green,
                            onPressed: () {
                              if (_jobAdTitle.text != '' &&
                                  _jobAdCompanyNumber.text != '') {
                                setState(() {
                                  _showProgress = !_showProgress;
                                });
                                if (_image != null) {
                                  uploadPicture(context).then((value) {
                                    addJobAdvertisementRequest(
                                        filter: '',
                                        jobAdTitle: _jobAdTitle.text,
                                        jobAdImageUrl:
                                            _jobAdImageUrl.toString(),
                                        jobAdCompanyNumber:
                                            _jobAdCompanyNumber.text,
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
                                      jobAdTitle: _jobAdTitle.text,
                                      jobAdImageUrl: _jobAdImageUrl.toString(),
                                      jobAdCompanyNumber:
                                          _jobAdCompanyNumber.text,
                                      jobAdPersonalNumber:
                                          _jobAdPersonalNumber.text,
                                      jobAdMail: _jobAdMail.text,
                                      jobAdContent: _jobAdContent.text,
                                      jobAdType: _selectedItem,
                                      jobAdDiploma: _diplomaItem);
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
