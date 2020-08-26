import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/job_adv/add_new_job_adv_screen.dart';
import 'package:alaev/screens/job_adv/my_job_advs_screen.dart';
import '../screens/job_adv/job_adv_detail_screen.dart';
import 'package:alaev/widgets/card_widget.dart';
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

  String _diplomaSelectedItem = 'Hepsi';
  String _categorySelectedItem = 'Hepsi';

  Future<void> fetchJobAdvs(String jobAdType, String jobAdDiploma) async {
    jobAdvList.clear();
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> filter;
    filter = {
      "state": 'active',
      "jobAdType": jobAdType,
      "jobAdDiploma": jobAdDiploma,
    };
    if (jobAdType == "Hepsi") {
      filter.remove("jobAdType");
    }
    if (jobAdDiploma == "Hepsi") {
      filter.remove("jobAdDiploma");
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
    fetchJobAdvs("Hepsi", "Hepsi");
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

  @override
  Widget build(BuildContext context) {
    List<String> diplomaItems = [
      'Hepsi',
      'Lise',
      'Önlisans - Öğrenci',
      'Önlisans - Mezun',
      'Üniversite - Öğrenci',
      'Üniversite - Mezun',
      'Yüksek Lisans',
      'Doktora'
    ];
    List<String> categoryItems = [
      'Hepsi',
      'Bilişim',
      'Gıda',
      'Sağlık',
      'Hizmet',
      'Tekstil',
      'Ticaret',
      'Yapı',
      'Otomotiv',
      'Eğitim',
      'Diğer'
    ];
    return Scaffold(
      key: _drawerKey,
      drawer: SafeArea(
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
                SizedBox(height: 35),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Öğrenim Durumu',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 17),
                    ),
                    SizedBox(height: 4),
                    Container(
                      color: Colors.indigo[50],
                      child: DropdownButton<String>(
                        elevation: 210,
                        isDense: true,
                        icon: Icon(Icons.arrow_drop_down),
                        value: _diplomaSelectedItem,
                        isExpanded: true,
                        onChanged: (String diplomaString) => setState(() {
                          _diplomaSelectedItem = diplomaString;
                        }),
                        selectedItemBuilder: (BuildContext context) {
                          return diplomaItems.map<Widget>((String diplomaItem) {
                            return Text(
                              diplomaItem,
                              style: TextStyle(fontSize: 17),
                            );
                          }).toList();
                        },
                        items: diplomaItems.map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text('$item'),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Kategori',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 17),
                    ),
                    SizedBox(height: 4),
                    DropdownButton<String>(
                      isDense: true,
                      icon: Icon(Icons.arrow_drop_down),
                      value: _categorySelectedItem,
                      isExpanded: true,
                      onChanged: (String categoryItemstring) => setState(() {
                        _categorySelectedItem = categoryItemstring;
                      }),
                      selectedItemBuilder: (BuildContext context) {
                        return categoryItems.map<Widget>((String categoryItem) {
                          return Text(
                            categoryItem,
                            style: TextStyle(fontSize: 17),
                          );
                        }).toList();
                      },
                      items: categoryItems.map((String categoryItem) {
                        return DropdownMenuItem<String>(
                          child: Text('$categoryItem'),
                          value: categoryItem,
                        );
                      }).toList(),
                    ),
                  ],
                ),
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
                          fetchJobAdvs(
                              _categorySelectedItem, _diplomaSelectedItem);
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
            icon:
                Icon(Icons.filter_list, color: Theme.of(context).primaryColor),
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            }),
        actions: <Widget>[
          SizedBox(width: 15),
          IconButton(
              icon: Icon(
                Icons.list,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                getUserRole().then((role) {
                  if (role == "Kurumsal") {
                    _pushNamedPage(context, MyJobAdvsScreen.routeName);
                  } else {
                    showToastError(
                        "Bu özelliği kullanabilmeniz için Kurumsal hesabınızın olması gerekir.");
                  }
                });
              }),
          IconButton(
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
              }),
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
        child: CardWidget(
          isJobPage: true,
          onRefresh: fetchJobAdvs,
          items: jobAdvList,
          isFirebase: true,
          isMyPage: false,
          routeName: JobAdvertisement.routeName,
        ),
      ),
    );
  }
}