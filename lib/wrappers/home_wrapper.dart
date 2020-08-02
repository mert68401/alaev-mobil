import 'package:alaev/widgets/carousel_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
                      SizedBox(height: 10),
                      CarouselWidget(),
                      Container(
                        height: 230,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: GridView.count(
                          childAspectRatio: 3 / 2,
                          primary: false,
                          crossAxisSpacing: 10.0,
                          crossAxisCount: 2,
                          children: <Widget>[
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
