import 'package:alaev/widgets/textfield_default.dart';
import 'package:flutter/material.dart';

class AppliedUserJobAdvCvScreen extends StatefulWidget {
  static const routeName = '/applied-user-job-adv-cv-screen';

  @override
  _AppliedUserJobAdvCvScreen createState() => _AppliedUserJobAdvCvScreen();
}

class _AppliedUserJobAdvCvScreen extends State<AppliedUserJobAdvCvScreen> {
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

  void dispose() {
    super.dispose();
  }

  Widget _personalInfoTab(context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
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
                      labelText: arguments['cvNameSurname'],
                      enabled: false,
                    ),
                    TextFieldWidget(
                      controller: _cvAge,
                      height: 50,
                      maxLines: 1,
                      maxLength: 2,
                      labelText: arguments['cvAge'],
                      enabled: false,
                    ),
                    TextFieldWidget(
                      controller: _cvMail,
                      height: 50,
                      maxLines: 1,
                      maxLength: 30,
                      labelText: arguments['cvMail'],
                      enabled: false,
                    ),
                    TextFieldWidget(
                      controller: _cvPhone,
                      height: 50,
                      maxLines: 1,
                      maxLength: 12,
                      labelText: arguments['cvPhone'],
                      enabled: false,
                    ),
                    TextFieldWidget(
                      controller: _cvPersonalInfo,
                      height: 150,
                      maxLines: 5,
                      maxLength: 200,
                      labelText: arguments['cvPersonalInfo'],
                      enabled: false,
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
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
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
                  labelText: arguments['cvSchool1'],
                  enabled: false,
                ),
                TextFieldWidget(
                  controller: _cvSchool2,
                  height: 75,
                  maxLines: 2,
                  maxLength: 70,
                  labelText: arguments['cvSchool2'],
                  enabled: false,
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
                  labelText: arguments['cvExperience1'],
                  enabled: false,
                ),
                TextFieldWidget(
                  controller: _cvExperience2,
                  height: 75,
                  maxLines: 1,
                  maxLength: 70,
                  labelText: arguments['cvExperience2'],
                  enabled: false,
                ),
                TextFieldWidget(
                  controller: _cvExperienceInfo,
                  height: 130,
                  maxLines: 7,
                  maxLength: 199,
                  labelText: arguments['cvExperienceInfo'],
                  enabled: false,
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
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
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
                  labelText: arguments['cvReference1'],
                  enabled: false,
                ),
                TextFieldWidget(
                  controller: _cvReference2,
                  height: 55,
                  maxLines: 1,
                  maxLength: 70,
                  labelText: arguments['cvReference2'],
                  enabled: false,
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
                  labelText: arguments['cvLanguage'],
                  enabled: false,
                ),
                TextFieldWidget(
                  controller: _cvSkillInfo,
                  height: 150,
                  maxLines: 7,
                  maxLength: 200,
                  labelText: arguments['cvSkillInfo'],
                  enabled: false,
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
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
          title: Text(
            arguments['cvNameSurname'] + ' Cv',
            style: TextStyle(color: Theme.of(context).primaryColor),
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
