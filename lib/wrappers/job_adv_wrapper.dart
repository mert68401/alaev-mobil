import 'dart:convert';

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

  Future<void> fetchJobAdvs() async {
    jobAdvList.clear();
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getJobAdvs',
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{
          "filter": {},
          "params": {
            "sort": {"createdAt": -1}
          },
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print(body);
      setState(() {
        body.forEach((element) {
          jobAdvList.add({
            "id": element["_id"],
            "title": element["jobAdTitle"],
            "content": element["jobAdContent"],
            "imageUrl": element["jobAdImageUrl"],
            "personalNumber": element["jobAdPersonalNumber"],
            "companyNumber": element["jobAdCompanyNumber"],
            "email": element["jobAdMail"],
          });
        });
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    super.initState();
    fetchJobAdvs();
  }

  void dispose() {
    super.dispose();
  }

  void _pushNamedPage(context, routeName) {
    Navigator.of(context).pushNamed(routeName);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.list),
              onPressed: () =>
                  _pushNamedPage(context, MyJobAdvsScreen.routeName)),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  _pushNamedPage(context, AddNewJobAdvScreen.routeName)),
        ],
        title: Text('İş İlanları'),
      ),
      body: CardWidget(
        onRefresh: fetchJobAdvs,
        items: jobAdvList,
        isFirebase: true,
        routeName: JobAdvertisement.routeName,
      ),
    );
  }
}
