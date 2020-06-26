import 'package:flutter/material.dart';

class NewsWrapper extends StatelessWidget {
  final List<String> newsTitle = [
    'title1ASDASDASDadsadsadsadsadsadsadsadsadsads',
    'title2ASDASDASDadsadsadsadsads',
    'title3ASDASDASDdsaaaaaaaa'
  ];
  final List<String> newsImage = [
    'assets/images/slide04.jpg',
    'assets/images/slide04.jpg',
    'assets/images/slide04.jpg'
  ];
  final List<String> newsSubTitle = ['Subtitle1', 'Subtitle2', 'Subtitle3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Duyurular'),
      ),
      body: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: newsTitle.length,
          itemBuilder: (BuildContext context, int i) {
            return Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(),
                  padding: EdgeInsets.only(bottom: 100),
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        leading: GestureDetector(
                          onTap: null,
                          child: Image.asset(newsImage[i]),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 80),
                  // padding: EdgeInsets.only(bottom: 50),
                  height: 100,
                  child: ListTile(
                    title: Text(
                      newsTitle[i],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(newsSubTitle[i]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
