import 'dart:convert';
import 'package:alaev/screens/job_adv/looking_for_job_cv_screen.dart';
import 'package:http/http.dart' as http;
import 'package:alaev/functions/functions.dart';
import 'package:alaev/functions/requests.dart';
import 'package:alaev/functions/server_ip.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobAdvertisement extends StatefulWidget {
  static const routeName = '/job-adv-page';

  @override
  _JobAdvertisementState createState() => _JobAdvertisementState();
}

class _JobAdvertisementState extends State<JobAdvertisement> {
  List<dynamic> userCvItems = [];

  bool isLoggedIn;

  Future<void> fetchUserCvData({String jobAdId}) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(
      'http://' + ServerIP().other + ':2000/api/getJobCvData',
      headers: headers,
      body: jsonEncode(
        <String, String>{
          "_id": jobAdId,
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          userCvItems = body;
        });
      }
    }
  }

  void initState() {
    super.initState();
    fetchUserCvData();
    getUserRole().then((role) {
      role == "Kurumsal" || role == "Bireysel"
          ? isLoggedIn = true
          : isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    String clickableCompanyNumber = arguments['companyNumber'];
    String clickablePersonalNumber = arguments['personalNumber'];
    String jobAdId = arguments['_id'];
    fetchUserCvData(jobAdId: jobAdId);
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
          arguments['jobType'] == 'İş Veren'
              ? Padding(
                  padding: EdgeInsets.all(3),
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    child: Text(
                      "Başvur",
                      style: TextStyle(fontSize: 13),
                    ),
                    onPressed: () {
                      if (isLoggedIn == true) {
                        getUserRole().then((role) {
                          role == "Kurumsal"
                              ? showToastError(
                                  'Kurumsal tip kullanıcılar iş başvurusu yapamaz!')
                              : applyJobRequest(jobAdId: jobAdId);
                        });
                      } else {
                        showToastError('Başvurmak için üye olunuz!');
                      }
                    },
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(3),
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    child: Text(
                      "CV",
                      style: TextStyle(fontSize: 13),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          LookingForJobCvScreen.routeName,
                          arguments: {"id": arguments["userId"]});
                    },
                  ),
                )
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
                    arguments['jobType'] == 'İş Veren'
                        ? Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Firma İsmi',
                                  textAlign: TextAlign.center),
                            )
                          ])
                        : Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('İsim Soyisim',
                                  textAlign: TextAlign.center),
                            )
                          ]),
                    arguments['jobType'] == 'İş Veren'
                        ? Column(children: [
                            Text(arguments['companyName'],
                                textAlign: TextAlign.center)
                          ])
                        : Column(children: [
                            Text(arguments['fullName'],
                                textAlign: TextAlign.center)
                          ]),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Şehir', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text(arguments['city'], textAlign: TextAlign.center),
                    ),
                  ]),
                  TableRow(children: [
                    arguments['jobType'] == 'İş Veren'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Firma Telefon Numarası',
                                textAlign: TextAlign.center),
                          )
                        : SizedBox(),
                    arguments['jobType'] == 'İş Veren'
                        ? GestureDetector(
                            onTap: () {
                              customLaunch('tel:$clickableCompanyNumber');
                            },
                            child: Text(
                              arguments['companyNumber'],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.indigo[800]),
                            ),
                          )
                        : SizedBox(),
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
