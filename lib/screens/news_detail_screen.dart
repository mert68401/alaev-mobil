import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsDetailScreen extends StatelessWidget {
  static const routeName = "/news-detail";
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text("Duyuru Detayı"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                arguments['title'],
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).accentColor),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Html(data: arguments['content']),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
