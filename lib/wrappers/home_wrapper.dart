import 'package:alaev/widgets/carousel_widget.dart';
import 'package:flutter/material.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  ScrollController _scrollController;
  double appBarRadius = 0;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          appBarRadius = _scrollController.offset;
        });
      });
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Anasayfa"),
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100 - appBarRadius * 4),
                bottomRight: Radius.circular(100 - appBarRadius * 4),
              ),
            ),
            elevation: 10,
            leading: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Icon(Icons.menu),
            ),
            floating: true,
            pinned: true,
            expandedHeight: 195,
            flexibleSpace: SafeArea(
              child: FlexibleSpaceBar(
                background: AspectRatio(
                  aspectRatio: 11 / 2,
                  child: Container(
                    margin: EdgeInsets.only(top: 50, bottom: 30),
                    child: Image.asset(
                      "./assets/images/alaevLogoClean.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      CarouselWidget(),
                      SizedBox(height: 50),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                            'ALA\'lı olmak, bir ömür boyu beraber olmaktır.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                      ),
                      SizedBox(height: 60),
                      Container(
                          child: Text(
                        'ALAEV Hakkında',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      )),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                            '       Adana Anadolu Lisesinin bir eğitim kurumu kimliği ile devamlılığını, gelişimini sağlayarak, mezunlar, öğrenciler ve mezun olmasalar dahi Adana Anadolu Lisesi’nde öğrenim görmüş tüm kişilerin sosyal dayanışmasını geliştirmek ve insanımızın kültürel, bilimsel ve sosyal gelişimine yüksek kalitede, etkin ve çağdaş eğitim hizmetleri ile katkıda bulunmak amacıyla kurulmuş bir vakıftır.',
                            style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
