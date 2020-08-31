import 'dart:ui';

import 'package:flutter/material.dart';

class MembersScreen extends StatelessWidget {
  static const routeName = '/members';

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
        body: Container(
          padding: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 20),
          child: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
            Text(
              'Yönetim Kurulu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'Asıl Üyeler',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Container(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: FractionColumnWidth(.5),
                      1: FractionColumnWidth(.16),
                      2: FractionColumnWidth(.35)
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                          ),
                          children: [
                            Column(children: [
                              Text('Adı Soyadı', textAlign: TextAlign.center)
                            ]),
                            Column(children: [
                              Text('Dönemi', textAlign: TextAlign.center)
                            ]),
                            Column(),
                          ]),
                      TableRow(children: [
                        Text('TUĞANA AKBAŞ', textAlign: TextAlign.center),
                        Text('ALA92', textAlign: TextAlign.center),
                        Text('Yönetim Kurulu Başkanı',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Text('AYKUT AKSU', textAlign: TextAlign.center),
                        Text('ALA83', textAlign: TextAlign.center),
                        Text('Yönetim Kurulu Başkan Vekili',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Text('HÜSEYİN ATICI', textAlign: TextAlign.center),
                        Text('ALA88', textAlign: TextAlign.center),
                        Text('Yönetim Kurulu Genel Sekreteri',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Text('AYLİN YILDIRIM', textAlign: TextAlign.center),
                        Text('ALA98', textAlign: TextAlign.center),
                        RichText(
                          maxLines: 2,
                          text: TextSpan(
                              text:
                                  '-----------------------------------------------------'),
                        ),
                      ]),
                      TableRow(children: [
                        Text('FATMA SERTEL', textAlign: TextAlign.center),
                        Text('ALA82', textAlign: TextAlign.center),
                        RichText(
                          maxLines: 2,
                          text: TextSpan(
                              text:
                                  '-----------------------------------------------------'),
                        ),
                      ]),
                      TableRow(children: [
                        Text('KEREM DOLAR', textAlign: TextAlign.center),
                        Text('ALA86', textAlign: TextAlign.center),
                        RichText(
                          maxLines: 2,
                          text: TextSpan(
                              text:
                                  '-----------------------------------------------------'),
                        ),
                      ]),
                      TableRow(children: [
                        Text('ABDÜLGANİ GİRİCİ', textAlign: TextAlign.center),
                        Text('ALA91', textAlign: TextAlign.center),
                        RichText(
                          maxLines: 2,
                          text: TextSpan(
                              text:
                                  '-----------------------------------------------------'),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Yedek Üyeler',
                style: TextStyle(fontSize: 16), textAlign: TextAlign.start),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Container(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: FractionColumnWidth(.5),
                      1: FractionColumnWidth(.16),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.orange),
                          children: [
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Adı Soyadı',
                                    textAlign: TextAlign.center),
                              )
                            ]),
                            Column(children: [
                              Text('Dönemi', textAlign: TextAlign.center)
                            ]),
                          ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('ELİF ÇİĞDEM BARBARUS',
                              textAlign: TextAlign.center),
                        ),
                        Text('ALA86', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child:
                              Text('VEDAT GİZER	', textAlign: TextAlign.center),
                        ),
                        Text('ALA87', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('NEŞE SONÇAĞ YAZAN',
                              textAlign: TextAlign.center),
                        ),
                        Text('ALA89', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('MELEK AKDOĞAN GEDİK',
                              textAlign: TextAlign.center),
                        ),
                        Text('ALA94', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('AYLİN HALLIOĞLU',
                              textAlign: TextAlign.center),
                        ),
                        Text('ALA95', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text('EBRU KOPAR', textAlign: TextAlign.center),
                        ),
                        Text('ALA96', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('BURCU PUL', textAlign: TextAlign.center),
                        ),
                        Text('ALA97', textAlign: TextAlign.center),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Denetim Kurulu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'Asıl Üyeler',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Container(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: FractionColumnWidth(.5),
                      1: FractionColumnWidth(.16),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.orange),
                          children: [
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Adı Soyadı',
                                    textAlign: TextAlign.center),
                              )
                            ]),
                            Column(children: [
                              Text('Dönemi', textAlign: TextAlign.center)
                            ]),
                          ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('MERİH ŞULE DEMİR',
                              textAlign: TextAlign.center),
                        ),
                        Text('ALA82', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text('ERDEM TECER	', textAlign: TextAlign.center),
                        ),
                        Text('ALA92', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('CEYDA YÜZÇELİK	',
                              textAlign: TextAlign.center),
                        ),
                        Text('ALA95', textAlign: TextAlign.center),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Yedek Üyeler',
                style: TextStyle(fontSize: 16), textAlign: TextAlign.start),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Container(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: FractionColumnWidth(.5),
                      1: FractionColumnWidth(.16),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.orange),
                          children: [
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Adı Soyadı',
                                    textAlign: TextAlign.center),
                              )
                            ]),
                            Column(children: [
                              Text('Dönemi', textAlign: TextAlign.center)
                            ]),
                          ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('FAİK KOCATEPE	',
                              textAlign: TextAlign.center),
                        ),
                        Text('ALA89', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text('EMRAH KOÇER	', textAlign: TextAlign.center),
                        ),
                        Text('ALA91', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('ARZU HAYRİYE ÖZCAN	',
                              textAlign: TextAlign.center),
                        ),
                        Text('ALA99', textAlign: TextAlign.center),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Mütevelli Heyeti Başkanlık Divanı',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Asıl Üyeler',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Container(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: FractionColumnWidth(.5),
                      1: FractionColumnWidth(.16),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.orange),
                          children: [
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Adı Soyadı', textAlign: TextAlign.center),
                              )
                            ]),
                            Column(children: [
                              Text('Dönemi', textAlign: TextAlign.center)
                            ]),
                          ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('UFUK KAYASELÇUK', textAlign: TextAlign.center),
                        ),
                        Text('ALA83', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('HASAN ERDAL DORUK', textAlign: TextAlign.center),
                        ),
                        Text('ALA84', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('ALİ SÜHA BİNGÖL', textAlign: TextAlign.center),
                        ),
                        Text('ALA85', textAlign: TextAlign.center),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Yedek Üyeler',
                style: TextStyle(fontSize: 16), textAlign: TextAlign.start),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Container(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: FractionColumnWidth(.5),
                      1: FractionColumnWidth(.16),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.orange),
                          children: [
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Adı Soyadı', textAlign: TextAlign.center),
                              )
                            ]),
                            Column(children: [
                              Text('Dönemi', textAlign: TextAlign.center)
                            ]),
                          ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('SIDIKA SUNAY BAHAR', textAlign: TextAlign.center),
                        ),
                        Text('ALA88', textAlign: TextAlign.center),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}
