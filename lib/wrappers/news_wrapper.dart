import 'dart:async';
import 'dart:convert';
import 'package:alaev/functions/server_ip.dart';
import 'package:alaev/screens/news_detail_screen.dart';
import 'package:alaev/widgets/card_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NewsWrapper extends StatefulWidget {
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
        print(newsList);
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    super.initState();

    fetchNews();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Duyurular'),
        ),
        body: CardWidget(
          items: newsList,
          onRefresh: fetchNews,
          isFirebase: false,
          isMyPage: false,
          routeName: NewsDetailScreen.routeName,
        ));
  }
}
