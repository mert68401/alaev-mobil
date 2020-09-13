import 'dart:convert';

import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/company_detail_screen.dart';
import 'package:alaev/widgets/card_discounted_places_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompanyListScreen extends StatefulWidget {
  static const routeName = '/company-list';

  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  final List<Map<String, dynamic>> discountedPlacesList = [];

  Future<void> getDiscountedPlaces() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getDiscountedPlaces',
      headers: headers,
      body: jsonEncode(<String, String>{}),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      setState(() {
        body.forEach((element) {
          discountedPlacesList.add({
            "companyName": element["companyName"],
            "companyDiscount": element["companyDiscount"],
            "companyAdress": element["companyAdress"],
          });
        });
      });
    } else {
      throw Exception('Failed to load');
    }
  }

  void initState() {
    super.initState();
    getDiscountedPlaces();
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
      body: CardDiscountedPlaces(
            onRefresh: getDiscountedPlaces,
            items: discountedPlacesList,
            routeName: CompanyDetailScreen.routeName),
    );
  }
}
