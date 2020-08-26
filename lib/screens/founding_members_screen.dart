import 'dart:ui';

import 'package:flutter/material.dart';

class FoundingMembersScreen extends StatelessWidget {
  static const routeName = '/founding-members';

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
                      0: FractionColumnWidth(.35),
                      1: FractionColumnWidth(.65),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.orange),
                          children: [
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('  Mezun Dönemi  ',
                                    textAlign: TextAlign.center),
                              )
                            ]),
                            Column(children: [
                              Text('  Kurucu Mütevelli  ',
                                  textAlign: TextAlign.center)
                            ]),
                          ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA82  ', textAlign: TextAlign.center),
                        ),
                        Text('  FATMA KAYHAN SERTEL  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA83  ', textAlign: TextAlign.center),
                        ),
                        Text('  UFUK KAYASELÇUK  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA84  ', textAlign: TextAlign.center),
                        ),
                        Text('  MUSTAFA CAN EREN  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA85  ', textAlign: TextAlign.center),
                        ),
                        Text('  ALİ SÜHA BİNGÖL  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA86  ', textAlign: TextAlign.center),
                        ),
                        Text('  ÇİĞDEM YANIÇOĞLU BARBARUS  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA87  ', textAlign: TextAlign.center),
                        ),
                        Text('  VEDAT GİZER  ', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA88  ', textAlign: TextAlign.center),
                        ),
                        Text('  HÜSEYİN ATICI  ', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA89  ', textAlign: TextAlign.center),
                        ),
                        Text('  ALPARSLAN KÜNİ  ', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA90  ', textAlign: TextAlign.center),
                        ),
                        Text('  MUSTAFA BÜLENT YAMAÇ  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA91  ', textAlign: TextAlign.center),
                        ),
                        Text('  GANİ GİRİCİ  ', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA92  ', textAlign: TextAlign.center),
                        ),
                        Text('  TUĞANA AKBAŞ  ', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA93  ', textAlign: TextAlign.center),
                        ),
                        Text('  SERDAR MART  ', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA94  ', textAlign: TextAlign.center),
                        ),
                        Text('  MELEK AKDOĞAN GEDİK  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA95  ', textAlign: TextAlign.center),
                        ),
                        Text('  AYLİN NECİOĞLU HALLIOĞLU  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA96  ', textAlign: TextAlign.center),
                        ),
                        Text('  SANEM KASAPOĞLU  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA97  ', textAlign: TextAlign.center),
                        ),
                        Text('  NAMIK KEMAL TÜYLÜCE  ',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA98  ', textAlign: TextAlign.center),
                        ),
                        Text('  AYLİN YILDIRIM  ', textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('  ALA99  ', textAlign: TextAlign.center),
                        ),
                        Text('  BAYRAM ÖCAL  ', textAlign: TextAlign.center),
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
