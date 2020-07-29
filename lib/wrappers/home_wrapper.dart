import 'package:alaev/widgets/carousel_widget.dart';
import 'package:alaev/wrappers/news_wrapper.dart';
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
            expandedHeight: 175,
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
                      SizedBox(height: 5),
                      CarouselWidget(),
                      Container(
                        height: 240,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: GridView.count(
                          padding: EdgeInsets.only(top:5),
                          childAspectRatio: 3 / 2,
                          primary: false,
                          crossAxisSpacing: 10.0,
                          crossAxisCount: 2,
                          children: <Widget>[
                            Card(
                                semanticContainer: true,
                                margin: EdgeInsets.only(bottom: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: InkWell(
                                  onTap: () {Navigator.of(context).pushNamed(NewsWrapper.routeName);},
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      ClipRRect(
                                        child: Image.asset(
                                          'assets/images/news.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        'DUYURULAR',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                            color: Colors.white,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.0, 4.0),
                                                blurRadius: 5.0,
                                                color: Colors.black87,
                                              ),
                                            ]),
                                      )
                                    ],
                                  ),
                                )),
                            Card(
                              margin: EdgeInsets.only(bottom: 10),
                              color: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: Column(
                                children: <Widget>[],
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.only(bottom: 10),
                              color: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: Column(
                                children: <Widget>[],
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.only(bottom: 10),
                              color: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: Column(
                                children: <Widget>[],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
