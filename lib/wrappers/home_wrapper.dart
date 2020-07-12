import 'package:alaev/widgets/carousel_widget.dart';
import 'package:flutter/material.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  void initState() {
    super.initState();
    Future<void> fetchAlbum() async {
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
        child: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        elevation: 10,
        leading: Icon(Icons.menu),
        floating: true,
        pinned: true,
        expandedHeight: 195,
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
        alignment: Alignment.topCenter,
        color: Theme.of(context).accentColor,
        child: Column(
          children: <Widget>[
            CarouselWidget(),
            // CarouselSlider(
            //   options: CarouselOptions(
            //     height: 200.0,
            //     autoPlay: true,
            //     autoPlayInterval: Duration(seconds: 3),
            //     autoPlayAnimationDuration: Duration(milliseconds: 800),
            //     autoPlayCurve: Curves.fastOutSlowIn,
            //     aspectRatio: 2.0,
            //   ),
            //   items: [
            //     'assets/images/slide04.jpg',
            //     'assets/images/slide01.jpg',
            //     'assets/images/1.jpg',
            //     'assets/images/2.jpg',
            //   ].map((i) {
            //     return Builder(
            //       builder: (BuildContext context) {
            //         return Container(
            //           width: MediaQuery.of(context).size.width,
            //           child: Image.asset(i),
            //         );
            //       },
            //     );
            //   }).toList(),
            // ),
            Container(
              child: Column(
                children: <Widget>[
                  Text(
                    'ALAEV Hakkında',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: <Widget>[
                      Text(' ALA\'lı olmak, bir ömür boyu beraber olmaktır.',
                          style: TextStyle(fontSize: 18))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: <Widget>[
                        Text(
                            "         Adana Anadolu Lisesinin bir eğitim kurumu kimliği ile devamlılığını, gelişimini sağlayarak, mezunlar, öğrenciler ve mezun olmasalar dahi Adana Anadolu Lisesi’nde öğrenim görmüş tüm kişilerin sosyal dayanışmasını geliştirmek ve insanımızın kültürel, bilimsel ve sosyal gelişimine yüksek kalitede, etkin ve çağdaş eğitim hizmetleri ile katkıda bulunmak amacıyla kurulmuş bir vakıftır. ",
                            textAlign: TextAlign.left),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    ]));
  }
}
