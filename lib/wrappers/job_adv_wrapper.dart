import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/job_adv/add_new_job_adv_screen.dart';
import 'package:alaev/screens/job_adv/my_job_advs_screen.dart';
import 'package:alaev/widgets/card_job_widget.dart';
import 'package:alaev/widgets/city_select.dart';
import 'package:alaev/widgets/drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_select/smart_select.dart';
import '../screens/job_adv/job_adv_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';

class JobAdvertisementWrapper extends StatefulWidget {
  @override
  _JobAdvertisementWrapperState createState() =>
      _JobAdvertisementWrapperState();
}

class _JobAdvertisementWrapperState extends State<JobAdvertisementWrapper> {
  final List<Map<String, String>> jobAdvList = [];

  bool _isFirma = false;
  String _diplomaSelectedItem = 'Hepsi';
  String _categorySelectedItem = 'Hepsi';
  String _citySelectedItem = 'Hepsi';
  int selectitem = 1;

  Future<void> fetchJobAdvs(
      String jobAdType, String jobAdDiploma, String city) async {
    jobAdvList.clear();
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> filter;
    filter = {
      "state": 'active',
      "jobAdType": jobAdType,
      "jobAdDiploma": jobAdDiploma,
      "city": city
    };
    if (jobAdType == "Hepsi") {
      filter.remove("jobAdType");
    }
    if (jobAdDiploma == "Hepsi") {
      filter.remove("jobAdDiploma");
    }
    if (city == "Hepsi") {
      filter.remove("city");
    }
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getJobAdvs',
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{
          "filter": filter,
          "params": {
            "sort": {"createdAt": -1}
          },
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          body.forEach((element) {
            jobAdvList.add({
              "_id": element["_id"],
              "createdAt": element['createdAt'],
              "title": element["jobAdTitle"],
              "content": element["jobAdContent"],
              "imageUrl": element["jobAdImageUrl"],
              "personalNumber": element["jobAdPersonalNumber"],
              "companyNumber": element["jobAdCompanyNumber"],
              "email": element["jobAdMail"],
              "type": element["jobAdType"],
              "diploma": element["jobAdDiploma"],
              "city": element["city"],
              "companyName": element["companyName"]
            });
          });
        });
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJobAdvs("Hepsi", "Hepsi", "Hepsi");
    getUserRole().then((value) {
      if (value == "Kurumsal") {
        setState(() {
          _isFirma = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _pushNamedPage(context, routeName) {
    Navigator.of(context).pushNamed(routeName);
    return;
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Widget smartSelect(String title, List options, String value) {
    return SmartSelect<String>.single(
        title: title,
        dense: false,
        isTwoLine: true,
        modalType: SmartSelectModalType.popupDialog,
        value: value,
        options: options,
        onChange: (val) => setState(() => _diplomaSelectedItem = val));
  }

  Widget smartSelect2(String title, List options, String value) {
    return SmartSelect<String>.single(
        title: title,
        dense: false,
        isTwoLine: true,
        modalType: SmartSelectModalType.popupDialog,
        value: value,
        options: options,
        onChange: (val) => setState(() => _categorySelectedItem = val));
  }

  Widget smartSelectCity() {
    return SmartSelect<String>.single(
        title: 'Şehir',
        padding: EdgeInsets.symmetric(horizontal: 15),
        dense: false,
        isTwoLine: true,
        modalType: SmartSelectModalType.popupDialog,
        value: _citySelectedItem,
        options: SmartSelectOption.listFrom<String, Map<String, String>>(
          source: cities,
          value: (index, item) => item['value'],
          title: (index, item) => item['title'],
        ),
        onChange: (val) => setState(() => _citySelectedItem = val));
  }

  @override
  Widget build(BuildContext context) {
    String citySelectedItem = 'Hepsi';

    List<SmartSelectOption<String>> categoryOptions = [
      SmartSelectOption<String>(value: 'Hepsi', title: 'Hepsi'),
      SmartSelectOption<String>(value: 'Bilişim', title: 'Bilişim'),
      SmartSelectOption<String>(value: 'Gıda', title: 'Gıda'),
      SmartSelectOption<String>(value: 'Sağlık', title: 'Sağlık'),
      SmartSelectOption<String>(value: 'Hizmet', title: 'Hizmet'),
      SmartSelectOption<String>(value: 'Tekstil', title: 'Tekstil'),
      SmartSelectOption<String>(value: 'Ticaret', title: 'Ticaret'),
      SmartSelectOption<String>(value: 'Yapı', title: 'Yapı'),
      SmartSelectOption<String>(value: 'Otomotiv', title: 'Otomotiv'),
      SmartSelectOption<String>(value: 'Eğitim', title: 'Eğitim'),
      SmartSelectOption<String>(value: 'Diğer', title: 'Diğer'),
    ];

    List<SmartSelectOption<String>> diplomaOptions = [
      SmartSelectOption<String>(value: 'Hepsi', title: 'Hepsi'),
      SmartSelectOption<String>(value: 'Lise', title: 'Lise'),
      SmartSelectOption<String>(
          value: 'Önlisans - Öğrenci', title: 'Önlisans - Öğrenci'),
      SmartSelectOption<String>(
          value: 'Önlisans - Mezun', title: 'Önlisans - Mezun'),
      SmartSelectOption<String>(
          value: 'Üniversite - Öğrenci', title: 'Üniversite - Öğrenci'),
      SmartSelectOption<String>(
          value: 'Üniversite - Mezun', title: 'Üniversite - Mezun'),
      SmartSelectOption<String>(
          value: 'Önlisans - Öğrenci', title: 'Önlisans - Öğrenci'),
      SmartSelectOption<String>(value: 'Yüksek Lisans', title: 'Yüksek Lisans'),
      SmartSelectOption<String>(value: 'Doktora', title: 'Doktora'),
    ];

    return Scaffold(
      key: _drawerKey,
      endDrawer: SafeArea(
        child: Drawer(
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          './assets/images/alaevLogoClean.png',
                          fit: BoxFit.cover,
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'Detaylı Arama',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: 15),
                smartSelectCity(),
                smartSelect(
                    'Öğrenim Durumu', diplomaOptions, _diplomaSelectedItem),
                smartSelect2(
                    'Kategori', categoryOptions, _categorySelectedItem),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Filtrele"),
                      textColor: Colors.white,
                      color: Colors.green,
                      onPressed: () {
                        setState(() {
                          fetchJobAdvs(_categorySelectedItem,
                              _diplomaSelectedItem, _citySelectedItem);
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
        actions: <Widget>[
          SizedBox(width: 15),
          IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
              onPressed: () {
                _drawerKey.currentState.openEndDrawer();
              }),
          _isFirma
              ? IconButton(
                  icon: Icon(
                    Icons.list,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    _pushNamedPage(context, MyJobAdvsScreen.routeName);
                  })
              : SizedBox(),
          _isFirma
              ? IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    getUserRole().then((role) {
                      print(role);
                      if (role == "Kurumsal") {
                        _pushNamedPage(context, AddNewJobAdvScreen.routeName);
                      } else {
                        showToastError(
                            "Bu özelliği kullanabilmeniz için Kurumsal hesabınızın olması gerekir.");
                      }
                    });
                  })
              : SizedBox(),
        ],
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
      ),
      body: Container(
          child: CardJobWidget(
              onRefresh: () => fetchJobAdvs(_diplomaSelectedItem,
                  _categorySelectedItem, _citySelectedItem),
              isFirebase: true,
              items: jobAdvList,
              routeName: JobAdvertisement.routeName)
          // CardWidget(
          //   isJobPage: true,
          //   onRefresh: fetchJobAdvs,
          //   items: jobAdvList,
          //   isFirebase: true,
          //   isMyPage: false,
          //   routeName: JobAdvertisement.routeName,
          // ),
          ),
    );
  }
}
