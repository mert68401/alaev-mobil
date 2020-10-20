import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailScreen extends StatelessWidget {
  static const routeName = '/user-detail-page';

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    print(arguments);
    String clickablePersonalNumber = arguments['phone'];

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
                  arguments['fullName'],
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
                        child:
                            Text('Mezuniyet Yılı', textAlign: TextAlign.center),
                      )
                    ]),
                    Column(children: [
                      Text(
                          arguments['graduateYear'] != null
                              ? arguments['graduateYear']
                              : '',
                          textAlign: TextAlign.center)
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Firma İsmi', textAlign: TextAlign.center),
                      )
                    ]),
                    Column(children: [
                      Text(
                          arguments['companyName'] != null
                              ? arguments['companyName']
                              : '',
                          textAlign: TextAlign.center)
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Bölüm', textAlign: TextAlign.center),
                      )
                    ]),
                    Column(children: [
                      Text(
                          arguments['universityFaculty'] != null
                              ? arguments['universityFaculty']
                              : '',
                          textAlign: TextAlign.center)
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Meslek', textAlign: TextAlign.center),
                      )
                    ]),
                    Column(children: [
                      Text(arguments['job'] != null ? arguments['job'] : '',
                          textAlign: TextAlign.center)
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Üniversite', textAlign: TextAlign.center),
                      )
                    ]),
                    Column(children: [
                      Text(
                          arguments['university'] != null
                              ? arguments['university']
                              : '',
                          textAlign: TextAlign.center)
                    ]),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Kişisel Telefon Numarası',
                          textAlign: TextAlign.center),
                    ),
                    GestureDetector(
                        onTap: () {
                          customLaunch("tel:" + clickablePersonalNumber);
                        },
                        child: Text(
                          arguments["phone"],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.indigo[800]),
                        )),
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
