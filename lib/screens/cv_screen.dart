import 'package:alaev/widgets/cv_tf_widget.dart';
import 'package:flutter/material.dart';

class CvScreen extends StatelessWidget {
  static const routeName = '/cv-screen';

  final cvNameSurname = TextEditingController();
  final cvAge = TextEditingController();
  final cvMail = TextEditingController();
  final cvPhone = TextEditingController();
  final cvPersonalInfo = TextEditingController();

  final cvSchool1 = TextEditingController();
  final cvSchool2 = TextEditingController();
  final cvExperience1 = TextEditingController();
  final cvExperience2 = TextEditingController();
  final cvExperienceInfo = TextEditingController();

  final cvReference1 = TextEditingController();
  final cvReference2 = TextEditingController();
  final cvLanguage = TextEditingController();
  final cvSkillInfo = TextEditingController();

  Widget personalInfoTab(context) {
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
                                    child: InkWell(
                                      onTap: null,
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
                    CvTextFieldWidget(
                      controller: cvNameSurname,
                      height: 50,
                      maxLines: 1,
                      maxLength: 20,
                      labelText: 'İsim Soyisim',
                    ),
                    CvTextFieldWidget(
                      controller: cvAge,
                      height: 50,
                      maxLines: 1,
                      maxLength: 2,
                      labelText: 'Yaşınız',
                    ),
                    CvTextFieldWidget(
                      controller: cvMail,
                      height: 50,
                      maxLines: 1,
                      maxLength: 30,
                      labelText: 'Mail',
                    ),
                    CvTextFieldWidget(
                      controller: cvPhone,
                      height: 50,
                      maxLines: 1,
                      maxLength: 12,
                      labelText: 'Telefon',
                    ),
                    CvTextFieldWidget(
                      controller: cvPersonalInfo,
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

  Widget experienceTab(context) {
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
                CvTextFieldWidget(
                  controller: cvSchool1,
                  height: 75,
                  maxLines: 2,
                  maxLength: 70,
                  labelText: 'Okul Adı, Bölüm, Mezuniyet Tarihi',
                ),
                CvTextFieldWidget(
                  controller: cvSchool2,
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
                CvTextFieldWidget(
                  controller: cvExperience1,
                  height: 75,
                  maxLines: 1,
                  maxLength: 70,
                  labelText: 'Firma Adı, Pozisyonunuz, Çalışma Süreniz',
                ),
                CvTextFieldWidget(
                  controller: cvExperience2,
                  height: 75,
                  maxLines: 1,
                  maxLength: 70,
                  labelText: 'Firma Adı, Pozisyonunuz, Çalışma Süreniz',
                ),
                CvTextFieldWidget(
                  controller: cvExperienceInfo,
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

  Widget skillTab(context) {
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
                CvTextFieldWidget(
                  controller: cvReference1,
                  height: 55,
                  maxLines: 1,
                  maxLength: 70,
                  labelText: 'Ad Soyad, Meslek, İletişim',
                ),
                CvTextFieldWidget(
                  controller: cvReference2,
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
                CvTextFieldWidget(
                  controller: cvLanguage,
                  maxLines: 2,
                  maxLength: 79,
                  labelText: 'Diller',
                ),
                CvTextFieldWidget(
                  controller: cvSkillInfo,
                  height: 150,
                  maxLines: 7,
                  maxLength: 200,
                  labelText: 'Yetkinliklerinizden Kısaca Bahsedin',
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text("Hepsini Kaydet"),
                        textColor: Colors.white,
                        color: Colors.green,
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  ],
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
            personalInfoTab(context),
            experienceTab(context),
            skillTab(context),
          ],
        ),
      ),
    );
  }
}
