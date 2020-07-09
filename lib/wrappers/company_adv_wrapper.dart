import 'dart:convert';

import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/company_adv/add_new_company_adv_screen.dart';
import 'package:alaev/screens/company_adv/my_company_advs_screen.dart';
import 'package:alaev/widgets/card_widget.dart';
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

  Future<void> fetchCompanyAdvs() async {
    advList.clear();
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getCompanyAdvs',
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
          advList.add({
            "id": element["_id"],
            "title": element["companyAdTitle"],
            "content": element["companyAdContent"],
            "imageUrl": element["companyAdImageUrl"]
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
                  _pushNamedPage(context, MyCompanyAdvsScreen.routeName)),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  _pushNamedPage(context, AddNewCompanyAdvScreen.routeName)),
        ],
        title: Text('Firma İlanları'),
      ),
      body: CardWidget(
        onRefresh: fetchCompanyAdvs,
        items: advList,
        isFirebase: true,
        isNews: false,
        routeName: CompanyAdvertisement.routeName,
      ),
    );
  }
}
