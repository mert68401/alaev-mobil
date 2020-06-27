import 'package:flutter/material.dart';

class CompanyAdvertisement extends StatelessWidget {
  static const routeName = '/companyadv-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlan'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                width: 100,
                height: 100,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child: Text(
                  'Firma Adı asdsaaaaaaaaaaaaasdadsadsadssdadsaaasdaa'
                      .substring(0, 26),
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 60, left: 20),
                alignment: Alignment.center,
                child: Text(
                  'Açıklama',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
