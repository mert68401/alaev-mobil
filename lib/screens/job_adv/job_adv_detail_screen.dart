import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/requests.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobAdvertisement extends StatefulWidget {
  static const routeName = '/job-adv-page';

  @override
  _JobAdvertisementState createState() => _JobAdvertisementState();
}

class _JobAdvertisementState extends State<JobAdvertisement> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    String clickableCompanyNumber = arguments['companyNumber'];
    String clickablePersonalNumber = arguments['personalNumber'];
    String jobAdId = arguments['_id'];

    void customLaunch(command) async {
      if (await canLaunch(command)) {
        await launch(command);
      } else {
        print(' could not launch $command');
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(3),
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              child: Text("Başvur", style: TextStyle(fontSize: 13),),
              onPressed: () {
                getUserRole().then((role) {
                  role == "Kurumsal"
                      ? showToastError(
                          'Kurumsal tip kullanıcılar iş başvurusu yapamaz!')
                      : applyJobRequest(jobAdId: jobAdId);
                });
              },
            ),
          ),
        ],
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
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                width: double.infinity,
                child: arguments['imageUrl'].toString().length > 1
                    ? Image.network(
                        arguments['imageUrl'],
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/empty.png",
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  arguments['title'],
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
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
                      child:
                          Text('Şehir', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        arguments['city'],
                        textAlign: TextAlign.center
                      ),
                    ),
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
                          Text('Eğitim Seviyesi', textAlign: TextAlign.center),
                    ),
                    Text(arguments['diploma'], textAlign: TextAlign.center),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Sektör', textAlign: TextAlign.center),
                    ),
                    Text(arguments['type'], textAlign: TextAlign.center),
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
