// import 'package:carousel_pro/carousel_pro.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  double appBarRadius = 0;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  void routePush() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => HomeWrapper()));
  }

  

  @override
  Widget build(BuildContext context) {
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
        //grid
        body: SizedBox()
        // slivers: <Widget>[
        //   SliverAppBar(
        //     backgroundColor: Colors.white,
        //     elevation: 20,
        //     leading: GestureDetector(
        //       onTap: () {
        //         Scaffold.of(context).openDrawer();
        //       },
        //       child: Icon(
        //         Icons.menu,
        //         color: Theme.of(context).primaryColor,
        //       ),
        //     ),
        //     floating: true,
        //     pinned: true,
        //     expandedHeight: 95,
        //     flexibleSpace: SafeArea(
        //       child: FlexibleSpaceBar(
        //         background: Container(
        //           margin: EdgeInsets.only(bottom: 60),
        //           child: Image.asset(
        //             "./assets/images/alaevLogoClean.png",
        //             scale: 11,
        //           ),
        //         ),
        //         centerTitle: true,
        //       ),
        //     ),
        //   ),
        //   SliverList(
        //     delegate: SliverChildListDelegate(
        //       [
        //         Container(
        //           width: double.infinity,
        //           alignment: Alignment.topCenter,
        //           child: Column(
        //             children: <Widget>[
        //               SizedBox(height: 5),
        //               // CarouselWidget(),
        //               Container(
        //                 height: 230,
        //                 width: MediaQuery.of(context).size.width - 40,
        //                 // child: Carousel(
        //                 //   boxFit: BoxFit.cover,
        //                 //   images: [
        //                 //     Image.asset('assets/images/slide04.jpg'),
        //                 //     Image.asset('assets/images/slide01.jpg'),
        //                 //     Image.asset('assets/images/1.jpg'),
        //                 //     Image.asset('assets/images/2.jpg'),
        //                 //   ],
        //                 //   dotSize: 4.0,
        //                 //   dotSpacing: 15.0,
        //                 //   dotColor: Colors.white,
        //                 //   animationDuration: Duration(seconds: 5),
        //                 //   autoplayDuration: Duration(seconds: 5),
        //                 //   indicatorBgPadding: 5.0,
        //                 //   dotBgColor: Theme.of(context).accentColor,
        //                 //   borderRadius: false,
        //                 //   dotIncreasedColor: Theme.of(context).primaryColor,
        //                 // ),
        //               ),
        //               // InkWell(
        //               //   onTap: () => customLaunch('http://alaev.org.tr'),
        //               //   child: Container(
        //               //       margin: EdgeInsets.all(20),
        //               //       child: Image.asset('assets/images/alaposter.jpg')),
        //               // )
        //               // Container(
        //               //   height: 240,
        //               //   width: MediaQuery.of(context).size.width / 1.2,
        //               //   child: GridView.count(
        //               //     padding: EdgeInsets.only(top: 5),
        //               //     childAspectRatio: 3 / 2,
        //               //     primary: false,
        //               //     crossAxisSpacing: 10.0,
        //               //     crossAxisCount: 2,
        //               //     children: <Widget>[
        //               //       Card(
        //               //           semanticContainer: true,
        //               //           margin: EdgeInsets.only(bottom: 5),
        //               //           shape: RoundedRectangleBorder(
        //               //             borderRadius: BorderRadius.circular(15),
        //               //           ),
        //               //           elevation: 4,
        //               //           clipBehavior: Clip.antiAliasWithSaveLayer,
        //               //           child: InkWell(
        //               //             onTap: () {
        //               //               Navigator.of(context)
        //               //                   .pushNamed(NewsWrapper.routeName);
        //               //             },
        //               //             child: Stack(
        //               //               alignment: Alignment.bottomCenter,
        //               //               fit: StackFit.expand,
        //               //               children: <Widget>[
        //               //                 ClipRRect(
        //               //                   child: Image.asset(
        //               //                     'assets/images/news.jpg',
        //               //                     fit: BoxFit.cover,
        //               //                   ),
        //               //                 ),
        //               //                 Text(
        //               //                   'DUYURULAR',
        //               //                   textAlign: TextAlign.center,
        //               //                   style: TextStyle(
        //               //                       color: Colors.white,
        //               //                       shadows: <Shadow>[
        //               //                         Shadow(
        //               //                           offset: Offset(1.0, 4.0),
        //               //                           blurRadius: 5.0,
        //               //                           color: Colors.black87,
        //               //                         ),
        //               //                       ]),
        //               //                 )
        //               //               ],
        //               //             ),
        //               //           )),
        //               //       Card(
        //               //         margin: EdgeInsets.only(bottom: 10),
        //               //         color: Colors.blueAccent,
        //               //         shape: RoundedRectangleBorder(
        //               //           borderRadius: BorderRadius.circular(15),
        //               //         ),
        //               //         elevation: 4,
        //               //         child: Column(
        //               //           children: <Widget>[],
        //               //         ),
        //               //       ),
        //               //       Card(
        //               //         margin: EdgeInsets.only(bottom: 10),
        //               //         color: Colors.blueAccent,
        //               //         shape: RoundedRectangleBorder(
        //               //           borderRadius: BorderRadius.circular(15),
        //               //         ),
        //               //         elevation: 4,
        //               //         child: Column(
        //               //           children: <Widget>[],
        //               //         ),
        //               //       ),
        //               //       Card(
        //               //         margin: EdgeInsets.only(bottom: 10),
        //               //         color: Colors.blueAccent,
        //               //         shape: RoundedRectangleBorder(
        //               //           borderRadius: BorderRadius.circular(15),
        //               //         ),
        //               //         elevation: 4,
        //               //         child: Column(
        //               //           children: <Widget>[],
        //               //         ),
        //               //       ),
        //               //     ],
        //               //   ),
        //               // )
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ],

        );
  }
}
