import 'dart:ui';

import 'package:flutter/material.dart';

class ChronologyScreen extends StatelessWidget {
  static const routeName = '/chronology';

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
              'Vakıf Kronolojisi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Container(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: {
                      0: FractionColumnWidth(.1),
                      1: FractionColumnWidth(.2),
                      2: FractionColumnWidth(.7),
                    },
                    children: [
                      TableRow(
                          decoration: BoxDecoration(color: Colors.orange),
                          children: [
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text('S.No', textAlign: TextAlign.center),
                              )
                            ]),
                            Column(children: [
                              Text('Tarih', textAlign: TextAlign.center)
                            ]),
                            Column(children: [
                              Text('Açıklama', textAlign: TextAlign.center)
                            ]),
                          ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('1', textAlign: TextAlign.center),
                        ),
                        Text('27.03.2018',
                            textAlign: TextAlign.center),
                        Text('Mezuniyetinin 20. yılını tamamlamış mezun dönemlerinin temsilcileriyle birlikte yapılan ilk toplantı. "HAZIR MISIN" çağrı metninin tüm dönem temsilcileri tarafından imzalandığı, vakıf kurma iradesinin ortaya çıktığı toplantı',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('2', textAlign: TextAlign.center),
                        ),
                        Text('23.04.2018',
                            textAlign: TextAlign.center),
                        Text('2. Toplantı, Vakıf senedinin taslağının tartışmaya açıldığı, vakıf kurma fikrinin tüm ALA camiasına duyurulmasına karar verildiği toplantı',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('3', textAlign: TextAlign.center),
                        ),
                        Text('24.04.2018',
                            textAlign: TextAlign.center),
                        Text('Tüm dönemleri vakfın kuruluşuna katılmaya çağıran “BİR ADIM ÖNE ÇIK” çağrısının tüm ALA gruplarında ve sosyal medyada duyurulması',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('4', textAlign: TextAlign.center),
                        ),
                        Text('07.05.2018',
                            textAlign: TextAlign.center),
                        Text('3. Toplantı, Vakıf senedinin taslağı, Bağış Kampanyası, Daimi Mütevellilerde aranacak özelliklerin görüşülmesi',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('5', textAlign: TextAlign.center),
                        ),
                        Text('14.05.2018',
                            textAlign: TextAlign.center),
                        Text('4. Toplantı, Vakıf senedinin taslağı, Kurucu Mütevelli sayısının belirlenmesi, Vakıf Adresi, G. Yönetim Kurulu üzerine görüşülmesi',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('6', textAlign: TextAlign.center),
                        ),
                        Text('21.05.2018', textAlign: TextAlign.center),
                        Text('5. Toplantı, Vakıf senedine son halinin verilmesi, Onursal Üyelik, Bağış Kampanyası üzerine görüşülmesi',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('7', textAlign: TextAlign.center),
                        ),
                        Text('30.05.2018', textAlign: TextAlign.center),
                        Text('Vakıf Senedinin 18 Kurucu Mütevellinin imzasıyla Noterde tescil edilmesi',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('8', textAlign: TextAlign.center),
                        ),
                        Text('07.06.2018', textAlign: TextAlign.center),
                        Text('Adana 1. Asliye Hukuk Mahkemesi’ne 2018/426 esas Sayılı dosyası ile Mahkeme başvurusunun yapılması',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('9', textAlign: TextAlign.center),
                        ),
                        Text('18.09.2018',
                            textAlign: TextAlign.center),
                        Text('1. Duruşmanın yapılması ve Mahkemenin vakıf senedinde tadilat ve blokeli banka hesabında düzeltme istemesi',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('10', textAlign: TextAlign.center),
                        ),
                        Text('28.09.2018', textAlign: TextAlign.center),
                        Text('Vakıf Senedi\'nde mahkemenin istediği tadilatın yapılması',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('11', textAlign: TextAlign.center),
                        ),
                        Text('10.10.2018', textAlign: TextAlign.center),
                        Text('Blokeli banka hesabının mahkemenin istediği şekilde düzeltilmesi',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('12', textAlign: TextAlign.center),
                        ),
                        Text('06.11.2018', textAlign: TextAlign.center),
                        Text('2. Duruşma',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('13', textAlign: TextAlign.center),
                        ),
                        Text('22.11.2018',
                            textAlign: TextAlign.center),
                        Text('Mahkemenin Kuruluş Kararı',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('14', textAlign: TextAlign.center),
                        ),
                        Text('13.03.2019',
                            textAlign: TextAlign.center),
                        Text('Mahkeme kararının itiraz süreleri beklendikten sonra kesinleşmesi',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('15', textAlign: TextAlign.center),
                        ),
                        Text('20.05.2019',
                            textAlign: TextAlign.center),
                        Text('Vakfın kuruluşunun Resmi Gazete\'de İlanı',
                            textAlign: TextAlign.center),
                      ]),
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('16', textAlign: TextAlign.center),
                        ),
                        Text('28.06.2019',
                            textAlign: TextAlign.center),
                        Text('1. Olağan Mütevelli Heyeti toplantımız',
                            textAlign: TextAlign.center),
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
