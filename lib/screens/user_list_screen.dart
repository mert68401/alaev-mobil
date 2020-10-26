import 'dart:convert';

import 'package:alaev/data/city_select.dart';
import 'package:alaev/data/faculties.dart';
import 'package:alaev/data/jobs.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/widgets/card_user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_select/smart_select.dart';
import 'dart:async';
import '../screens/user_list_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  static const routeName = '/user-list';

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final List<Map<String, dynamic>> userList = [];
  final _searchController = TextEditingController();
  String _facultySelectedItem;
  String _jobSelectedItem;
  String _citySelectedItem;
  Future<void> fetchUserAccounts({String regex = ""}) async {
    userList.clear();
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> filter;
    filter = {
      "job": _jobSelectedItem,
      "universityFaculty": _facultySelectedItem,
      "city": _citySelectedItem
    };

    if (_jobSelectedItem == null || _jobSelectedItem == 'Hepsi') {
      filter.remove("job");
    }
    if (_facultySelectedItem == null || _facultySelectedItem == 'Hepsi') {
      filter.remove("universityFaculty");
    }
    if (_citySelectedItem == null || _citySelectedItem == 'Hepsi') {
      filter.remove("city");
    }

    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getUserAccounts',
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{
          "regex": _searchController.text,
          "filter": filter,
          "params": {
            "sort": {"createdAt": -1}
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      setState(() {
        body.forEach((element) {
          userList.add({
            "fullName": element["fullName"],
            "graduateYear": element["graduateYear"],
            "job": element["job"],
            "showPhone": element["showPhone"],
            "phone": element["phone"],
            "companyName": element["companyName"],
            "city": element["city"],
            "universityFaculty": element["universityFaculty"],
            "university": element["university"]
          });
        });
      });
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  void initState() {
    super.initState();
    fetchUserAccounts();
  }

  void dispose() {
    super.dispose();
  }

  Widget smartSelectFaculty(String title, String value) {
    return SmartSelect<String>.single(
        placeholder: "Şeçiniz",
        title: title,
        modalType: S2ModalType.popupDialog,
        modalFilter: true,
        value: value,
        choiceItems: S2Choice.listFrom<String, Map<String, String>>(
          source: facultiesListAll,
          value: (index, item) => item['value'],
          title: (index, item) => item['title'],
        ),
        onChange: (val) => setState(() => _facultySelectedItem = val.value));
  }

  Widget smartSelectJob(String title, String value) {
    return SmartSelect<String>.single(
        placeholder: "Şeçiniz",
        title: title,
        modalType: S2ModalType.popupDialog,
        modalFilter: true,
        value: value,
        choiceItems: S2Choice.listFrom<String, Map<String, String>>(
          source: jobsListAll,
          value: (index, item) => item['value'],
          title: (index, item) => item['title'],
        ),
        onChange: (val) => setState(() => _jobSelectedItem = val.value));
  }

  Widget smartSelectCity(String title, String value) {
    return SmartSelect<String>.single(
        placeholder: "Şeçiniz",
        title: title,
        modalType: S2ModalType.popupDialog,
        modalFilter: true,
        value: value,
        choiceItems: S2Choice.listFrom<String, Map<String, String>>(
          source: cities,
          value: (index, item) => item['value'],
          title: (index, item) => item['title'],
        ),
        onChange: (val) => setState(() => _citySelectedItem = val.value));
  }
  // void _pushNamedPage(context, routeName) {
  //   Navigator.of(context).pushNamed(routeName);
  //   return;
  // }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: true,
      key: _drawerKey,
      endDrawer: Drawer(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            children: [
              DrawerHeader(
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
                'Arama',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              // Text(
              //   '(Yaptığınız arama ad-soyad, meslek, üniversite, şehir, telefon numarası gibi alanlarda arama yapar.)',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 12),
              // ),
              SizedBox(height: 15),

              Container(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    isDense: true,
                    hintText: "Kelimeye göre arama",
                    fillColor: Colors.white,
                    hintStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                  ),
                  // onChanged: onSearchTextChanged,
                ),
              ),
              smartSelectFaculty("Bölüm", _facultySelectedItem),
              smartSelectJob("Meslek", _jobSelectedItem),
              smartSelectCity("Şehir", _citySelectedItem),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: RaisedButton(
                  child: Text("Filtrele"),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      fetchUserAccounts(regex: _searchController.text);
                      Navigator.pop(context);
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
              onPressed: () {
                _drawerKey.currentState.openEndDrawer();
              }),
        ],
        backgroundColor: Colors.white,
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
          child: CardUserListWidget(
        onRefresh: fetchUserAccounts,
        items: userList,
        routeName: UserDetailScreen.routeName,
      )
          // CardWidget(
          //   isJobPage: false,
          //   onRefresh: fetchCompanyAdvs,
          //   items: advList,
          //   isFirebase: true,
          //   isMyPage: false,
          //   routeName: CompanyAdvertisement.routeName,
          // ),
          ),
    );
  }
}
