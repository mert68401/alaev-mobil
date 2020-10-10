import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';

class LookingForJobCvScreen extends StatefulWidget {
  static const routeName = '/looking-for-job-cv-screen';

  @override
  _LookingForJobCvScreen createState() => _LookingForJobCvScreen();
}

class _LookingForJobCvScreen extends State<LookingForJobCvScreen> {
  String _cvImageUrl = "";
  String id = "";
  bool requested = false;
  final _cvNameSurname = TextEditingController();
  final _cvAge = TextEditingController();
  final _cvMail = TextEditingController();
  final _cvPhone = TextEditingController();
  final _cvPersonalInfo = TextEditingController();

  final _cvSchool1 = TextEditingController();
  final _cvSchool2 = TextEditingController();
  final _cvExperience1 = TextEditingController();
  final _cvExperience2 = TextEditingController();
  final _cvExperienceInfo = TextEditingController();

  final _cvReference1 = TextEditingController();
  final _cvReference2 = TextEditingController();
  final _cvLanguage = TextEditingController();
  final _cvSkillInfo = TextEditingController();

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> cvRequest(String id) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getUserCvDataById',
      headers: headers,
      body: jsonEncode(
        <String, String>{"id": id},
      ),
    );
    if (response.statusCode == 200) {
      dynamic userData = jsonDecode(response.body);
      setState(() {
        _cvImageUrl = userData['cvImageUrl'];
      });
      _cvNameSurname.text = userData['cvNameSurname'];
      _cvAge.text = userData['cvAge'];
      _cvMail.text = userData['cvMail'];
      _cvPhone.text = userData['cvPhone'];
      _cvPersonalInfo.text = userData['cvPersonalInfo'];
      _cvSchool1.text = userData['cvSchool1'];
      _cvSchool2.text = userData['cvSchool2'];
      _cvExperience1.text = userData['cvExperience1'];
      _cvExperience2.text = userData['cvExperience2'];
      _cvExperienceInfo.text = userData['cvExperienceInfo'];
      _cvReference1.text = userData['cvReference1'];
      _cvReference2.text = userData['cvReference2'];
      _cvLanguage.text = userData['cvLanguage'];
      _cvSkillInfo.text = userData['cvSkillInfo'];
    } else if (response.statusCode == 401) {
      showToastError(jsonDecode(response.body)['message'].toString());
    }
  }

  Future uploadPicture(BuildContext ctx) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    _cvImageUrl = await taskSnapshot.ref.getDownloadURL();
  }

  Map<String, dynamic> userData = {};

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget _personalInfoTab(context) {
    return Container(
      height: MediaQuery.of(context).devicePixelRatio,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: <Widget>[
                Container(
                  height: 140,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Stack(fit: StackFit.loose, children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                width: 100,
                                height: 100,
                                child: _image == null
                                    ? _cvImageUrl == "" || _cvImageUrl == null
                                        ? Image.asset(
                                            "assets/images/empty.png",
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            _cvImageUrl,
                                            fit: BoxFit.cover,
                                          )
                                    : Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ],
                          ),
                          Container(
                              height: 120,
                              padding: EdgeInsets.only(top: 60.0, right: 80.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    radius: 20.0,
                                    child: GestureDetector(
                                      onTap: () => getImage(),
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    TextFieldWidget(
                      controller: _cvNameSurname,
                      height: 50,
                      maxLines: 1,
                      maxLength: 20,
                      labelText: 'İsim Soyisim',
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      controller: _cvAge,
                      height: 50,
                      maxLines: 1,
                      maxLength: 2,
                      labelText: 'Yaşınız',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      controller: _cvMail,
                      height: 50,
                      maxLines: 1,
                      maxLength: 30,
                      labelText: 'Mail',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      controller: _cvPhone,
                      height: 50,
                      maxLines: 1,
                      maxLength: 12,
                      labelText: 'Telefon',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextFieldWidget(
                      controller: _cvPersonalInfo,
                      height: 150,
                      maxLines: 5,
                      maxLength: 200,
                      labelText: 'Kısaca Kendinizden Bahsedin',
                      counterText: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _experienceTab(context) {
    return Container(
      height: MediaQuery.of(context).devicePixelRatio,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Eğitim Bilgileri',
                      style: TextStyle(fontSize: 20),
                    )),
                SizedBox(height: 10),
                TextFieldWidget(
                  controller: _cvSchool1,
                  height: 95,
                  maxLines: 3,
                  maxLength: 70,
                  labelText: 'Okul Adı, Bölüm, Mezuniyet Tarihi',
                ),
                SizedBox(height: 10),
                TextFieldWidget(
                  controller: _cvSchool2,
                  height: 95,
                  maxLines: 3,
                  maxLength: 70,
                  labelText: 'Okul Adı, Bölüm, Mezuniyet Tarihi',
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  child: Text(
                    'Tecrübeler',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 10),
                TextFieldWidget(
                  controller: _cvExperience1,
                  height: 95,
                  maxLines: 3,
                  maxLength: 70,
                  labelText: 'Firma Adı, Pozisyonunuz, Çalışma Süreniz',
                ),
                SizedBox(height: 10),
                TextFieldWidget(
                  controller: _cvExperience2,
                  height: 95,
                  maxLines: 3,
                  maxLength: 70,
                  labelText: 'Firma Adı, Pozisyonunuz, Çalışma Süreniz',
                ),
                SizedBox(height: 10),
                TextFieldWidget(
                  controller: _cvExperienceInfo,
                  height: 130,
                  maxLines: 7,
                  maxLength: 199,
                  labelText: 'Kısaca Tecrübelerinizden Bahsediniz',
                  counterText: null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _skillTab(context) {
    return Container(
      height: MediaQuery.of(context).devicePixelRatio,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Referanslar',
                      style: TextStyle(fontSize: 20),
                    )),
                SizedBox(height: 10),
                TextFieldWidget(
                  controller: _cvReference1,
                  height: 75,
                  maxLines: 2,
                  maxLength: 60,
                  labelText: 'Ad Soyad, Meslek, İletişim',
                ),
                SizedBox(height: 10),
                TextFieldWidget(
                  controller: _cvReference2,
                  height: 75,
                  maxLines: 2,
                  maxLength: 60,
                  labelText: 'Ad Soyad, Meslek, İletişim',
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'Yetenekler/Yetkinlikler',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 10),
                TextFieldWidget(
                  controller: _cvLanguage,
                  maxLines: 2,
                  maxLength: 60,
                  labelText: 'Diller',
                ),
                SizedBox(height: 10),
                TextFieldWidget(
                  controller: _cvSkillInfo,
                  height: 150,
                  maxLines: 7,
                  maxLength: 200,
                  labelText: 'Yetkinliklerinizden Kısaca Bahsedin',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (requested == false) {
      cvRequest(arguments["id"]);
      requested = true;
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
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
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Text('Kişisel Bilgiler',
                      style: TextStyle(color: Theme.of(context).primaryColor))),
              Tab(
                  child: Text('Eğitim, Tecrübe',
                      style: TextStyle(color: Theme.of(context).primaryColor))),
              Tab(
                  child: Text('Yetkinlikler',
                      style: TextStyle(color: Theme.of(context).primaryColor))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _personalInfoTab(context),
            _experienceTab(context),
            _skillTab(context),
          ],
        ),
      ),
    );
  }
}
