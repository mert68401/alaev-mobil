import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  void initState() {
    super.initState();
    Future<void> fetchAlbum() async {
      Map<String, String> headers = {"Content-type": "application/json"};
      // final response = await http.post(
      //   'http://alaev.org.tr:2000/api/posts',
      //   headers: headers,
      //   body: jsonEncode(
      //     <String, dynamic>{
      //       "filter": {},
      //       "params": {
      //         "sort": {"createdAt": -1}
      //       }
      //     },
      //   ),
      // );

      // if (response.statusCode == 200) {
      //   print(response.body);
      // } else {
      //   throw Exception('Failed to load album');
      // }
    }

    fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 10,
            leading: Icon(Icons.menu),
            floating: true,
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: AspectRatio(
                aspectRatio: 11 / 2,
                child: Image.asset(
                  "assets/images/slide04.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              centerTitle: true,
              title: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 30),
                          children: <TextSpan>[
                            TextSpan(
                                text: "ALA",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor)),
                            TextSpan(text: "EV")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Container(
              color: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
    );
  }
}
