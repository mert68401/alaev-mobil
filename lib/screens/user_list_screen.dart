import 'dart:convert';

import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/widgets/card_user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../screens/user_list_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  static const routeName = '/user-list';

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final List<Map<String, String>> userList = [];

  Future<void> fetchUserAccounts() async {
    userList.clear();
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getUserAccounts',
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{},
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
            "phone": element["phone"],
            "companyName": element["companyName"],
            "city": element["city"],
            "university": element["university"]
          });
        });
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    super.initState();
    fetchUserAccounts();
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
