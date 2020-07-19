import 'dart:convert';
import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/job_adv/applied_user_job_adv_screen.dart';
import 'package:alaev/screens/job_adv/edit_my_job_advs_screen.dart';
import 'package:alaev/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyJobAdvsScreen extends StatefulWidget {
  static const routeName = '/my-job-advs-screen';

  @override
  _MyJobAdvsScreenState createState() => _MyJobAdvsScreenState();
}

class _MyJobAdvsScreenState extends State<MyJobAdvsScreen> {
  final List<Map<String, dynamic>> myJobAdvList = [];

  Future<void> fetchUserJobAdvs() async {
    getToken().then((value) async {
      myJobAdvList.clear();
      Map<String, String> headers = {"Content-type": "application/json"};
      final response = await http.post(
        'http://' + ServerIP().other + ':2000/api/getUserJobAdvs',
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
        print(jsonDecode(response.body));
        List<dynamic> body = jsonDecode(response.body);
        setState(() {
          body.forEach((element) {
            myJobAdvList.add({
              "_id": element["_id"],
              "createdAt": element['createdAt'],
              "title": element["jobAdTitle"],
              "content": element["jobAdContent"],
              "imageUrl": element["jobAdImageUrl"],
              "appliedUsers": element["appliedUsers"] != null
                  ? element["appliedUsers"].toList()
                  : null,
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

    fetchUserJobAdvs();

  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Mevcut İş İlanlarım')),
        body: CardWidget(
          onRefresh: fetchUserJobAdvs,
          items: myJobAdvList,
          isFirebase: true,
          isMyPage: true,
          isMyJobPage: true,
          routeName: AppliedUsersJobAdvScreen.routeName,
        ));
  }
}
