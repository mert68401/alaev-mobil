import 'dart:async';
import 'dart:convert';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/news_detail_screen.dart';
import 'package:alaev/widgets/card_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NewsWrapper extends StatefulWidget {
  static const routeName = '/news';
  @override
  _NewsWrapperState createState() => _NewsWrapperState();
}

class _NewsWrapperState extends State<NewsWrapper> {
  final List<Map<String, String>> newsList = [];
  Future<void> fetchNews() async {
    newsList.clear();

    Map<String, String> headers = {"Content-type": "application/json"};
    if (!mounted) return;
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/posts',
      headers: headers,
      body: jsonEncode(
        <String, dynamic>{
          "filter": {},
          "params": {
            "sort": {"createdAt": -1}
          }
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          body.forEach((element) {
            newsList.add({
              "_id": element["_id"],
              "title": element["title"],
              "content": element["content"],
              "imageUrl": element["image"],
              "createdAt": element['createdAt']
            });
          });
        });
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    super.initState();

    fetchNews();
  }

  @override
  void dispose() {
    super.dispose();
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

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
          key: _drawerKey,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            // leading: IconButton(
            //     icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
            //     onPressed: () {
            //       Scaffold.of(context).openDrawer();
            //     }),
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
              isJobPage: false,
              items: newsList,
              onRefresh: fetchNews,
              isFirebase: false,
              isMyPage: false,
              routeName: NewsDetailScreen.routeName,
            ),
          )),
    );
  }
}
