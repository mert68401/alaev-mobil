import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyAdvertisement extends StatelessWidget {
  static const routeName = '/company-adv-page';

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    String clickableCompanyNumber = arguments['companyNumber'];
    String clickablePersonalNumber = arguments['personalNumber'];

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
              arguments['imageUrl'].toString().length > 1
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        arguments['imageUrl'],
                        fit: BoxFit.cover,
                      ))
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  arguments['title'],
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
                  0: FractionColumnWidth(.35),
                  1: FractionColumnWidth(.65),
                },
                children: [
                  TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Firma İsmi', textAlign: TextAlign.center),
                      )
                    ]),
                    Column(children: [
                      Text(arguments['companyName'],
                          textAlign: TextAlign.center)
                    ]),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Firma Telefon Numarası',
                          textAlign: TextAlign.center),
                    ),
                    GestureDetector(
                      onTap: () {
                        customLaunch('tel:$clickableCompanyNumber');
                      },
                      child: Text(
                        arguments['companyNumber'],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.indigo[800]),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Kişisel Telefon Numarası',
                          textAlign: TextAlign.center),
                    ),
                    GestureDetector(
                        onTap: () {
                          customLaunch('tel:$clickablePersonalNumber');
                        },
                        child: Text(
                          arguments['personalNumber'],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.indigo[800]),
                        )),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Mail Adresi', textAlign: TextAlign.center),
                    ),
                    Text(
                      arguments['email'],
                      textAlign: TextAlign.center,
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('İlan Ayrıntısı', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        arguments['content'],
                        textAlign: TextAlign.center,
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
