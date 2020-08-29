import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsDetailScreen extends StatelessWidget {
  static const routeName = "/news-detail";
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: arguments['imageUrl'].toString().length > 1
                    ? Image.network(
                        "http://statik.wiki.com.tr/assets/alaev/img/" +
                            arguments['imageUrl'],
                        fit: BoxFit.cover,
                      )
                    : SizedBox(height: 0)),
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
