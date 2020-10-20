import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDetailScreen extends StatelessWidget {
  static const routeName = '/company-detail-page';

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    void customLaunch(command) async {
      if (await canLaunch(command)) {
        await launch(command);
      } else {
        print(' could not launch $command');
      }
    }

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  arguments['companyName'],
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(color: Colors.grey),
                columnWidths: {
                  0: FractionColumnWidth(.3),
                  1: FractionColumnWidth(.7),
                },
                children: [
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Firma İndirimi',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      '%' + arguments['companyDiscount'],
                      textAlign: TextAlign.center,
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Firma Adresi',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          customLaunch(
                              "https://www.google.com.tr/maps/search/" +
                                  Uri.encodeFull(arguments['companyAdress'])
                                      .replaceAll(new RegExp("/"), "+"));
                        },
                        child: Text(
                          arguments['companyAdress'],
                          style: TextStyle(color: Colors.blueAccent),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
