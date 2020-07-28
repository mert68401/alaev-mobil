import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWidget extends StatefulWidget {
  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentIndex = 0;
  int index;

  List cardList = [
    'assets/images/slide04.jpg',
    'assets/images/slide01.jpg',
    'assets/images/1.jpg',
    'assets/images/2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            height: 170.0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
          items: cardList.map((card) {
            return Builder(builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(),
                // border: Border.all(),
                // borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width - 100,
                child: Card(
                  color: Theme.of(context).accentColor,
                  child: Image.asset(
                    card,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}
