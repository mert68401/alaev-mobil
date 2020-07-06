import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final double width;
  final double height;
  final double paddingTop;
  final double paddingRight;
  IconWidget({this.width, this.height, this.paddingTop, this.paddingRight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Stack(fit: StackFit.loose, children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn4.iconfinder.com/data/icons/political-elections/50/48-128.png'), // dynamic yaz
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        Container(
            height: 70,
            padding: EdgeInsets.only(top: paddingTop, right: paddingRight,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 18.0,
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                )
              ],
            )),
      ]),
    );
  }
}
