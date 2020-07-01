import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NewsWrapper extends StatefulWidget {
  @override
  _NewsWrapperState createState() => _NewsWrapperState();
}

class _NewsWrapperState extends State<NewsWrapper> {
  final List<Map<String, String>> liste = [];
  double _currentOpacity = 0;
  Future<void> fetchNews() async {
    liste.clear();

    print(liste.length);
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://alaev.org.tr:2000/api/posts',
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
      print(body);
      setState(() {
        body.forEach((element) {
          liste.add({
            "_id": element["_id"],
            "title": element["title"],
            "content": element["content"],
            "imageUrl": element["image"]
          });
        });

        new Timer(Duration(milliseconds: 200), () {
          setState(() {
            _currentOpacity = 1;
          });
        });
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
      body: RefreshIndicator(
        onRefresh: fetchNews,
        child: Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: liste.length,
            itemBuilder: (BuildContext context, int i) {
              return AnimatedOpacity(
                opacity: _currentOpacity,
                duration: Duration(milliseconds: 500),
                child: InkWell(
                  onTap: () => null,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                "http://statik.wiki.com.tr/assets/alaev/img/" +
                                    liste[i]['imageUrl'],
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 10,
                              child: Container(
                                width: 300,
                                color: Colors.black54,
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 20,
                                ),
                                child: Text(
                                  liste[i]['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  liste[i]
                                      ['content'], //.substring(0, 95) + '...',
                                  style: TextStyle(fontSize: 15),
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
