import 'dart:convert';
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
    myAdvList.clear();
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://10.0.2.2:2000/api/getUserCompanyAdvs',
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{
          "token": {},
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print(body);
      setState(() {
        body.forEach((element) {
          myAdvList.add({
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

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('Mevcut Firma İlanlarım')),
      body: CardWidget(
          onRefresh: null,
          items: null,
          isFirebase: true,
        ));
  }
}
