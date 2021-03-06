import 'dart:convert';

import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/company_adv/add_new_company_adv_screen.dart';
import 'package:alaev/screens/company_adv/my_company_advs_screen.dart';
import 'package:alaev/screens/home_screen.dart';
import 'package:alaev/widgets/card_company_widget.dart';
import 'package:alaev/wrappers/home_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../screens/company_adv/company_adv_detail_screen.dart';

class CompanyAdvertisementWrapper extends StatefulWidget {
  @override
  _CompanyAdvertisementWrapperState createState() =>
      _CompanyAdvertisementWrapperState();
}

class _CompanyAdvertisementWrapperState
    extends State<CompanyAdvertisementWrapper> {
  final List<Map<String, String>> advList = [];

  bool _isLoggedIn = false;

  Future<void> fetchCompanyAdvs() async {
    advList.clear();
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getCompanyAdvs',
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{
          "filter": {
            "state": 'active',
          },
          "params": {
            "sort": {"createdAt": -1}
          },
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      setState(() {
        body.forEach((element) {
          advList.add({
            "_id": element["_id"],
            "createdAt": element['createdAt'],
            "title": element["companyAdTitle"],
            "content": element["companyAdContent"],
            "imageUrl": element["companyAdImageUrl"],
            "personalNumber": element["companyAdPersonalNumber"],
            "companyNumber": element["companyAdCompanyNumber"],
            "email": element["companyAdMail"],
            "companyName": element["companyName"]
          });
        });
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    super.initState();
    fetchCompanyAdvs();
    getUserRole().then((value) {
      if (value == "Kurumsal" || value == "Bireysel") {
        setState(() {
          _isLoggedIn = true;
        });
      }
    });
  }

  void dispose() {
    super.dispose();
  }

  void _pushNamedPage(context, routeName) {
    Navigator.of(context).pushNamed(routeName);
    return;
  }

  // GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            buttonPadding: EdgeInsets.all(15),
            title: new Text('Emin misin?'),
            content: new Text('Uygulamayı kapatmak istiyor musun'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("HAYIR"),
              ),
              SizedBox(width: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("EVET"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        // key: _drawerKey,
        appBar: AppBar(
          // leading: IconButton(
          //     icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
          //     onPressed: () {
          //       Scaffold.of(context).openDrawer();
          //     }),
          backgroundColor: Colors.white,
          actions: <Widget>[
            _isLoggedIn
                ? IconButton(
                    icon: Icon(
                      Icons.list,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _pushNamedPage(context, MyCompanyAdvsScreen.routeName);
                    },
                  )
                : SizedBox(),
            _isLoggedIn
                ? IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _pushNamedPage(context, AddNewCompanyAdvScreen.routeName);
                    },
                  )
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
            child: CardCompanyWidget(
                onRefresh: fetchCompanyAdvs,
                items: advList,
                routeName: CompanyAdvertisement.routeName)
            // CardWidget(
            //   isJobPage: false,
            //   onRefresh: fetchCompanyAdvs,
            //   items: advList,
            //   isFirebase: true,
            //   isMyPage: false,
            //   routeName: CompanyAdvertisement.routeName,
            // ),
            ),
      ),
    );
  }
}
