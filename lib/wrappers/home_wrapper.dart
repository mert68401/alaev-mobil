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
        child: CustomScrollView(
          // physics: BouncingScrollPhysics(),
          slivers: <Widget>[
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
      SliverList(
          delegate: SliverChildListDelegate([
        Container(
          alignment: Alignment.topCenter,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 80),
              CarouselWidget(),
              SizedBox(height: 50),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(' ALA\'lı olmak, bir ömür boyu beraber olmaktır.',
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Container(
                  child: Text(
                'ALAEV Hakkında',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              )),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                    '       Adana Anadolu Lisesinin bir eğitim kurumu kimliği ile devamlılığını, gelişimini sağlayarak, mezunlar, öğrenciler ve mezun olmasalar dahi Adana Anadolu Lisesi’nde öğrenim görmüş tüm kişilerin sosyal dayanışmasını geliştirmek ve insanımızın kültürel, bilimsel ve sosyal gelişimine yüksek kalitede, etkin ve çağdaş eğitim hizmetleri ile katkıda bulunmak amacıyla kurulmuş bir vakıftır.', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 15),
            ],
          ),
        )
      ])),
    ]));
  }
}
