import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/job_adv/add_new_job_adv_screen.dart';
import 'package:alaev/screens/job_adv/my_job_advs_screen.dart';
import 'package:alaev/widgets/card_job_widget.dart';
import 'package:alaev/data/city_select.dart';
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
              "userId": element["userId"],
              "createdAt": element['createdAt'],
              "jobAdType": element["jobAdType"],
              "title": element["jobAdTitle"],
              "content": element["jobAdContent"],
              "imageUrl": element["jobAdImageUrl"],
              "personalNumber": element["jobAdPersonalNumber"],
              "companyNumber": element["jobAdCompanyNumber"],
              "email": element["jobAdMail"],
              "type": element["jobAdType"],
              "diploma": element["jobAdDiploma"],
              "city": element["city"],
              "companyName": element["companyName"],
              "jobType": element["jobType"],
              "fullName": element["fullName"]
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
      if (value == "Kurumsal" || value == "Bireysel") {
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
        modalType: S2ModalType.popupDialog,
        value: value,
        choiceItems: options,
        onChange: (val) => setState(() => _diplomaSelectedItem = val.value));
  }

  Widget smartSelect2(String title, List options, String value) {
    return SmartSelect<String>.single(
        title: title,
        modalType: S2ModalType.popupDialog,
        value: value,
        choiceItems: options,
        onChange: (val) => setState(() => _categorySelectedItem = val.value));
  }

  Widget smartSelectCity() {
    return SmartSelect<String>.single(
        title: 'Şehir',
        modalType: S2ModalType.popupDialog,
        value: _citySelectedItem,
        choiceItems: S2Choice.listFrom<String, Map<String, String>>(
          source: cities,
          value: (index, item) => item['value'],
          title: (index, item) => item['title'],
        ),
        onChange: (val) => setState(() => _citySelectedItem = val.value));
  }

  @override
  Widget build(BuildContext context) {
    String citySelectedItem = 'Hepsi';

    List<S2Choice<String>> categoryOptions = [
      S2Choice<String>(value: 'Hepsi', title: 'Hepsi'),
      S2Choice<String>(value: 'Bilişim', title: 'Bilişim'),
      S2Choice<String>(value: 'Gıda', title: 'Gıda'),
      S2Choice<String>(value: 'Sağlık', title: 'Sağlık'),
      S2Choice<String>(value: 'Hizmet', title: 'Hizmet'),
      S2Choice<String>(value: 'Tekstil', title: 'Tekstil'),
      S2Choice<String>(value: 'Ticaret', title: 'Ticaret'),
      S2Choice<String>(value: 'Yapı', title: 'Yapı'),
      S2Choice<String>(value: 'Otomotiv', title: 'Otomotiv'),
      S2Choice<String>(value: 'Eğitim', title: 'Eğitim'),
      S2Choice<String>(value: 'Diğer', title: 'Diğer'),
    ];

    List<S2Choice<String>> diplomaOptions = [
      S2Choice<String>(value: 'Hepsi', title: 'Hepsi'),
      S2Choice<String>(value: 'Lise', title: 'Lise'),
      S2Choice<String>(
          value: 'Önlisans - Öğrenci', title: 'Önlisans - Öğrenci'),
      S2Choice<String>(
          value: 'Önlisans - Mezun', title: 'Önlisans - Mezun'),
      S2Choice<String>(
          value: 'Üniversite - Öğrenci', title: 'Üniversite - Öğrenci'),
      S2Choice<String>(
          value: 'Üniversite - Mezun', title: 'Üniversite - Mezun'),
      S2Choice<String>(
          value: 'Önlisans - Öğrenci', title: 'Önlisans - Öğrenci'),
      S2Choice<String>(value: 'Yüksek Lisans', title: 'Yüksek Lisans'),
      S2Choice<String>(value: 'Doktora', title: 'Doktora'),
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
                          Navigator.pop(context);
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
                    _pushNamedPage(context, AddNewJobAdvScreen.routeName);
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
