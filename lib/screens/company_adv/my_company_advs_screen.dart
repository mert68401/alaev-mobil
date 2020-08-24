import 'dart:convert';
import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/company_adv/edit_my_company_advs_screen.dart';
import 'package:alaev/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyCompanyAdvsScreen extends StatefulWidget {
  static const routeName = '/my-company-advs-screen';

  @override
  _MyCompanyAdvsScreenState createState() => _MyCompanyAdvsScreenState();
}

class _MyCompanyAdvsScreenState extends State<MyCompanyAdvsScreen> {
  final List<Map<String, String>> myAdvList = [];

  Future<void> fetchUserCompanyAdvs() async {
    getToken().then((value) async {
      myAdvList.clear();
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        'http://' + ServerIP().other + ':2000/api/getUserCompanyAdvs',
        headers: headers,
        body: jsonEncode(
          <String, dynamic>{
            "token": value,
            "filter": {},
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
            myAdvList.add({
              "_id": element["_id"],
              "title": element["companyAdTitle"],
              "content": element["companyAdContent"],
              "imageUrl": element["companyAdImageUrl"]
            });
          });
        });
      } else {
        throw Exception('Failed to load album');
      }
    });
  }

  void initState() {
    super.initState();

    fetchUserCompanyAdvs();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
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
        body: CardWidget(
          isJobPage: false,
          onRefresh: fetchUserCompanyAdvs,
          items: myAdvList,
          isFirebase: true,
          isMyPage: true,
          routeName: EditMyCompanyAdvScreen.routeName,
        ));
  }
}
