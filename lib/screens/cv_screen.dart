import 'dart:convert';
import 'package:alaev/functions/functions.dart';
import 'package:http/http.dart' as http;

import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';

import '../functions/functions.dart';
import '../functions/requests.dart';

class CvScreen extends StatefulWidget {
  static const routeName = '/cv-screen';

  @override
  _CvScreenState createState() => _CvScreenState();
}

class _CvScreenState extends State<CvScreen> {
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

  Map<String, dynamic> userData = {};

  void initState() {
    super.initState();

    Future<void> cvRequest() async {
      getToken().then((value) async {
        Map<String, String> headers = {"Content-type": "application/json"};
        final response = await http.post(
          'http://10.0.2.2:2000/api/getUserCvData',
          headers: headers,
          body: jsonEncode(
            <String, String>{"token": value},
          ),
        );
        if (response.statusCode == 200) {
          print("Cv oluşturuldu");
          userData = json.decode(response.body);
          print(userData);
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
      });
    }

    cvRequest();
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
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://cdn4.iconfinder.com/data/icons/political-elections/50/48-128.png'), // dynamic yaz
                                    fit: BoxFit.cover,
                                  ),
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
                                      onTap: () => null,
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
                    TextFieldWidget(
                      controller: _cvAge,
                      height: 50,
                      maxLines: 1,
                      maxLength: 2,
                      labelText: 'Yaşınız',
                    ),
                    TextFieldWidget(
                      controller: _cvMail,
                      height: 50,
                      maxLines: 1,
                      maxLength: 30,
                      labelText: 'Mail',
                    ),
                    TextFieldWidget(
                      controller: _cvPhone,
                      height: 50,
                      maxLines: 1,
                      maxLength: 12,
                      labelText: 'Telefon',
                    ),
                    TextFieldWidget(
                      controller: _cvPersonalInfo,
                      height: 150,
                      maxLines: 5,
                      maxLength: 200,
                      labelText: 'Kısaca Kendinizden Bahsedin',
                      counterText: null,
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
                TextFieldWidget(
                  controller: _cvSchool1,
                  height: 75,
                  maxLines: 2,
                  maxLength: 70,
                  labelText: 'Okul Adı, Bölüm, Mezuniyet Tarihi',
                ),
                TextFieldWidget(
                  controller: _cvSchool2,
                  height: 75,
                  maxLines: 2,
                  maxLength: 70,
                  labelText: 'Okul Adı, Bölüm, Mezuniyet Tarihi',
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  child: Text(
                    'Tecrübeler',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextFieldWidget(
                  controller: _cvExperience1,
                  height: 75,
                  maxLines: 1,
                  maxLength: 70,
                  labelText: 'Firma Adı, Pozisyonunuz, Çalışma Süreniz',
                ),
                TextFieldWidget(
                  controller: _cvExperience2,
                  height: 75,
                  maxLines: 1,
                  maxLength: 70,
                  labelText: 'Firma Adı, Pozisyonunuz, Çalışma Süreniz',
                ),
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
                TextFieldWidget(
                  controller: _cvReference1,
                  height: 55,
                  maxLines: 1,
                  maxLength: 70,
                  labelText: 'Ad Soyad, Meslek, İletişim',
                ),
                TextFieldWidget(
                  controller: _cvReference2,
                  height: 55,
                  maxLines: 1,
                  maxLength: 70,
                  labelText: 'Ad Soyad, Meslek, İletişim',
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'Yetenekler/Yetkinlikler',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextFieldWidget(
                  controller: _cvLanguage,
                  maxLines: 2,
                  maxLength: 79,
                  labelText: 'Diller',
                ),
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Colors.green,
          onPressed: () {
            addCvRequest(
              cvNameSurname: _cvNameSurname.text,
              cvAge: _cvAge.text,
              cvExperience1: _cvExperience1.text,
              cvExperience2: _cvExperience2.text,
              cvExperienceInfo: _cvExperienceInfo.text,
              cvLanguage: _cvLanguage.text,
              cvMail: _cvMail.text,
              cvPersonalInfo: _cvPersonalInfo.text,
              cvPhone: _cvPhone.text,
              cvReference1: _cvReference1.text,
              cvReference2: _cvReference2.text,
              cvSchool1: _cvSchool1.text,
              cvSchool2: _cvSchool2.text,
              cvSkillInfo: _cvSkillInfo.text,
            );
          },
        ),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Kişisel Bilgiler'),
              Tab(text: 'Eğitim, Tecrübe'),
              Tab(text: 'Yetkinlikler'),
            ],
          ),
          title: Text('CV Ekle/Düzenle'),
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
