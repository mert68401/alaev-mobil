import 'package:flutter/material.dart';

class NewsWrapper extends StatelessWidget {
  final List<Map<String, String>> liste = [
    {
      'title': 'Başlık',
      'imageUrl': 'assets/images/slide04.jpg',
      'subTitle':
          'Altyazıasddddddddddddddddddassadsadaaaaaaaaaaaaaadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsads'
    },
    {
      'title': 'Başlık',
      'imageUrl': 'assets/images/slide04.jpg',
      'subTitle':
          'Altyazıasddddddddddddddddddassadsadaaaaaaaaaaaaaadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsads'
    },
    {
      'title': 'Başlık',
      'imageUrl': 'assets/images/slide04.jpg',
      'subTitle':
          'Altyazıasddddddddddddddddddassadsadaaaaaaaaaaaaaadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsads'
    }
  ];

  // final List<String> newsTitle = [
  //   'title1ASDASDASDadsadsadsadsadsadsadsadsadsads',
  //   'title2ASDASDASDadsadsadsadsads',
  //   'title3ASDASDASDdsaaaaaaaa'
  // ];
  // final List<String> newsImage = [
  //   'assets/images/slide04.jpg',
  //   'assets/images/slide04.jpg',
  //   'assets/images/slide04.jpg'
  // ];

  // final List<String> newsSubTitle = [
  //   'Subtitle1adsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsadsads',
  //   'Subtitle2',
  //   'Subtitle3'
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Duyurular'),
      ),
      body: Container(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: liste.length,
          itemBuilder: (BuildContext context, int i) {
            return InkWell(
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
                          child: Image.asset(
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
                                fontSize: 26,
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
                              liste[i]['subTitle'], //.substring(0, 95) + '...',
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
            );
          },
        ),
      ),
    );
  }
}
